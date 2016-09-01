class AdtekioAdnetworks::Cost::Vungle
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:api_key]
  end

  def load_campaign_ids
    uri = Addressable::URI.parse("https://ssl.vungle.com/api/campaigns")
    uri.query_values = {
      :key => credentials.api_key,
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end

    JSON.parse(res.body, :symbolize_names => true).map do |campaign|
      campaign[:campaignId]
    end
  end

  def campaign_costs(from, till)
    campaign_ids = load_campaign_ids
    from.upto(till).map do |date|
      campaign_ids.map do |id|
        sleep 0.11 # max 100 requests per 10 seconds are allowed
        uri = Addressable::URI.
          parse("https://ssl.vungle.com/api/campaigns/#{id}")

        uri.query_values = {
          :key  => credentials.api_key,
          :date => date.strftime("%Y-%m-%d"),
        }

        req = Net::HTTP::Get.new(uri.request_uri)
        res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                              :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
          http.request(req)
        end

        JSON.parse(res.body, :symbolize_names => true).map do |campaign|
          next if campaign[:dailySpend].to_f == 0
          {
            :date        => date,
            :campaign    => campaign[:name],
            :amount      => campaign[:dailySpend].to_f,
            :impressions => campaign[:impressions].to_i,
            :clicks      => campaign[:clicks].to_i,
            :conversions => campaign[:installs].to_i
          }
        end.compact
      end
    end.flatten
  end
end
