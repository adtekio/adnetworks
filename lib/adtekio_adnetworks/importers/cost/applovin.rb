class AdtekioAdnetworks::Cost::Applovin
  include AdtekioAdnetworks::CostImport

  def campaign_name(country, device, date, campaign_name)
    name_parts = [country, device]

    /\{(.*)\}/i.match(campaign_name) do |m|
      name_parts.push($1)
    end

    name_parts.join('_').downcase
  end

  def campaign_costs(from, till)
    uri = Addressable::URI.parse("https://r.applovin.com/report")
    uri.query_values = {
      :api_key  => credentials.api_key,
      :start    => from.to_s,
      :end      => till.to_s,
      :columns  => "day,campaign,device_type,country,impressions,clicks,conversions,cost",
      :report_type => "advertiser",
      :format   => :json,
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end

    JSON.parse(res.body)['results'].reject do |campaign|
      campaign["cost"].to_i == 0
    end.map do |campaign|
      date   = Date.parse(campaign['day'])

      {
        :date           => date,
        :campaign       => campaign_name(campaign['country'], campaign['device_type'], date, campaign['campaign']),
        :impressions    => campaign['impressions'].to_i,
        :clicks         => campaign['clicks'].to_i,
        :conversions    => campaign['conversions'].to_i,
        :amount         => campaign['cost'].to_f,
        :target_country => campaign['country'],
        :target_device  => campaign['device_type'],
      }
    end
  end
end
