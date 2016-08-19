class AdtekioAdnetworks::Cost::Supersonic
  include AdtekioAdnetworks::CostImport

  def load_data(uri)
    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth credentials.login, credentials.key

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end

    JSON.parse(res.body, :symbolize_names => true)[:data]
  end

  def campaigns
    uri = Addressable::URI.
      parse("https://platform.supersonic.com/partners/advertiser/campaigns")
    load_data(uri)
  end

  def stats(campaign_ids, date)
    uri = Addressable::URI.
      parse("https://platform.supersonic.com/partners/advertiser/campaigns/stats")
    uri.query_values = {
      :start_date   => date.strftime("%Y-%m-%d"),
      :end_date     => date.strftime("%Y-%m-%d"),
      :campaign_id  => campaign_ids.join(',')
    }
    load_data(uri)
  end

  def mobile_campaign_costs(from, till)
    campaign_hsh = campaigns.group_by do |campaign|
      campaign[:campaign_id].to_i
    end

    from.upto(till).map do |date|
      stats(campaign_hsh.keys, date).map do |campaign_stats|

        campaign_id = campaign_stats[:campaign_id].to_i
        campaign    = campaign_hsh[campaign_id].first

        platform = case campaign[:target_platform].first
                   when 'apple_itunes' then 'ios'
                   when 'google_play' then 'android'
                   else nil
                   end

        next if campaign[:bundle_id].nil?

        campaign_stats[:data].map do |stats|
          country = stats[:country_code].downcase

          {
            :date           => date,
            :campaign       => campaign[:campaign_name],
            :adgroup        => country,
            :impressions    => stats[:impressions].to_i,
            :clicks         => stats[:clicks].to_i,
            :conversions    => stats[:conversions].to_i,
            :amount         => stats[:expense].to_f / 100,
            :target_country => country,
          }
        end
      end.compact.flatten
    end.flatten
  end

  def campaign_costs(from, till)
    mobile_campaign_costs(from, till)
  end
end
