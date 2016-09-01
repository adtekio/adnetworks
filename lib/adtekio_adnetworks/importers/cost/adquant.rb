class AdtekioAdnetworks::Cost::Adquant
  include AdtekioAdnetworks::CostImport

  API_ENDPOINT = "https://rpc.mb4w.com/"
  AUTH_ROUTE   = "auth"
  DATA_ROUTE   = "report/grid"

  define_required_credentials do
    [:username, :password]
  end

  def campaign_costs(from, till)
    load_data.map do |campaign_data|
      campaign_name = campaign_data[:fcg_name]
      adgroup_name  = campaign_data[:fbc_name].
        sub(/(#{Regexp.escape(campaign_name)}_)/i, "").sub('%) ', '_')
      ad_name       = campaign_data[:fba_name].
        sub(/(#{Regexp.escape(campaign_name)}_#{Regexp.escape(adgroup_name)}_)/i, "")

      {
        :date         => Date.parse(campaign_data[:date]).to_s,
        :campaign     => campaign_name,
        :adgroup      => adgroup_name,
        :ad           => ad_name,
        :impressions  => campaign_data[:fb_unique_imps],
        :clicks       => campaign_data[:fb_unique_clicks],
        :conversions  => campaign_data[:conversion],
        :amount       => campaign_data[:dst_amount][:USD]
      }
    end.select { |d| (from..till).include?(Date.parse(d[:date])) }
  end

  private

  def load_data
    params = {
      :token    => api_token,
      :groups   => ["cpn_id", "fcg_id", "fbc_id", "fba_id", "date"].to_json,
      :values   => ["cpn_id", "fcg_id", "fbc_id", "fba_id", "date", "dst_amount",
                    "act_action_date", "conversions", "fb_unique_imps",
                    "fb_unique_clicks", "cpn_title"].to_json,
    }
    make_request(params, DATA_ROUTE)[:rowset]
  end

  def api_token
    @api_token ||= begin
                     params = {
        :usr_email => credentials.username,
        :usr_pwd   => credentials.password
      }
                     response_json = make_request(params, AUTH_ROUTE)
                     response_json[:token]
                   end
  end

  def make_request(params, route)
    response = ::RestClient::Request.
      execute(method:       :post,
              content_type: 'application/json',
              url:          "#{API_ENDPOINT}#{route}",
              payload:      params,
              headers:      {"Accept-Encoding" => "deflate"},
              ssl_version:  :SSLv23)

    JSON.parse(response.to_str, :symbolize_names => true)[:data]
  end
end
