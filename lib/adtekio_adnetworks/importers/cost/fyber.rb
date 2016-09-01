class AdtekioAdnetworks::Cost::Fyber
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:username, :password]
  end

  def apps
    uri = Addressable::URI.
      parse("https://api.sponsorpay.com/advertiser/v1/application_list")

    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth credentials.username, credentials.password

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end
    JSON.parse(res.body, :symbolize_names => true)[:data]
  end

  def campaign_costs(from, till)
    apps.map do |app_data|
      next if app_data[:bundle_id].nil?

      uri = Addressable::URI.
        parse("https://api.sponsorpay.com/advertiser/v1/campaign_aggregate")

      uri.query_values = {
        :app_id     => app_data[:app_id],
        :start_day  => from.strftime("%Y-%m-%d"),
        :end_day    => till.strftime("%Y-%m-%d"),
      }
      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth credentials.username, credentials.password
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                            :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        http.request(req)
      end

      JSON.parse(res.body, :symbolize_names => true)[:data].map do |campaign|
        next if campaign[:spend].to_f == 0
        {
          :date        => Date.parse(campaign[:day]),
          :campaign    => campaign[:campaign_name].split(' ').first,
          :impressions => campaign[:impressions].to_i,
          :clicks      => campaign[:clicks].to_i,
          :conversions => campaign[:downloads].to_i,
          :amount      => campaign[:spend].to_f/100,
        }
      end.compact
    end.flatten
  end
end
