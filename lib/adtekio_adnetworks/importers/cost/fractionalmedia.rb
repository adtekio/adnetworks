class AdtekioAdnetworks::Cost::Fractionalmedia
  include AdtekioAdnetworks::CostImport

  API_ENDPOINT  = 'https://ws.fractionalmedia.com/ws'

  define_required_credentials do
    [:username, :password]
  end

  def http_call(method, login_required=false, params={})
    uri = Addressable::URI.parse("#{API_ENDPOINT}/#{method}.js")
    uri.query_values = params

    if login_required
      req = Net::HTTP::Get.new(uri.request_uri)
      req['Cookie'] = cookies.map(&:to_s).join('; ') if login_required
    else
      req = Net::HTTP::Post.new(uri.request_uri)
    end

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end
  end

  def cookies
    @cookie ||=
      begin
        http_call(:login, false,
                  :user => credentials.username,
                  :pw   => credentials.password
                  ).get_fields('Set-Cookie').map do |cookie_string|
                    cookie = CGI::Cookie.parse(cookie_string)
                    CGI::Cookie.new('name'  => cookie.first.first,
                                    'value' => cookie.first.last,
                                    'path'  => cookie['Path'])
                  end
      end
  end

  def load_compaign_metrics(from, till, id)
    response = http_call(:get_perf_hist, true, {
                           campid: id,
                           days: (Date.today - from).to_i
                         })

    json_data = JSON(response.body, :symbolize_names => true).try(:[], :data) || []
    json_data.map do |metric|
      metric[:date] = Date.parse(metric[:date])
      metric
    end.select do |metric|
      metric[:date] >= from and metric[:date] <= till
    end.reject do |metric|
      metric[:revenue] == 0
    end
  end

  def load_campaigns(from, till, id=25092)
    response = http_call(:get_all_camps, true, current: id)
    campaigns = JSON(response.body, :symbolize_names => true)[:camps]
    campaigns.map do |campaign_data|
      info = URI.unescape(campaign_data[:title]);

      name, country, platform, dump =
        info.split('~').map(&:strip).map(&:downcase)
      app, campaign, ad = parse_name(name, country, platform)

      {
        :id       => campaign_data[:id],
        :app      => app,
        :campaign => campaign,
        :ad       => ad,
        :country  => country,
        :platform => platform
      }
    end.compact.map do |campaign_data|
      campaign_data[:metrics] = load_compaign_metrics(from, till, campaign_data[:id])
      campaign_data
    end
  end

  def parse_name(name, country, platform)
    app, ad = name.split('=')
    [app, "#{app}_#{country}_#{platform}", ad]
  end

  def campaign_costs(from, till)
    load_campaigns(from, till).map do |campaign|
      campaign[:metrics].map do |campaign_metric|
        {
          :campaign       => campaign[:campaign],
          :adgroup        => :banner,
          :ad             => campaign[:ad],
          :date           => campaign_metric[:date],
          :conversions    => campaign_metric[:convs],
          :amount         => campaign_metric[:revenue],
          :target_country => campaign[:country],
          :target_device  => campaign[:platform]
        }
      end
    end.flatten
  end
end
