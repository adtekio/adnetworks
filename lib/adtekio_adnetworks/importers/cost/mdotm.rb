class AdtekioAdnetworks::Cost::Mdotm
  include AdtekioAdnetworks::CostImport

  def campaigns(from, till)
    uri = Addressable::URI.parse("http://ads.mdotm.com/api/1.0/getCampaigns")
    uri.query_values = {
      :email              => credentials.username,
      :secretKey          => credentials.api_key,
      :startDT            => from.to_s,
      :endDT              => till.to_s,
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    JSON.parse(res.body)['response']['campaigns'].map do |campaign|
      campaign['adGroups'].map do |adgroup|
        (adgroup['performance'] || []).map do |performance|
          filtered = performance.select do |key, _|
            ['impressions', 'clicks','conversions','price', 'logDate'].include? key
          end
          filtered['app'] = ""
          filtered['campaign'] = campaign['campaignName']
          filtered['adgroup'] = adgroup['adGroupName']
          filtered
        end
      end
    end.flatten.group_by do |campaign|
      [campaign['logDate'], campaign['campaign'], campaign['adgroup']]
    end.map do |key, campaigns|
      campaigns.inject({}) do |memo, campaign|
        memo.merge(campaign) do |key, old_v, new_v|
          if ['campaign', 'app', 'logDate', 'adgroup'].include? key
            old_v
          elsif key == 'price'
            old_v.to_f + new_v.to_f
          else
            old_v.to_i + new_v.to_i
          end
        end
      end
    end
  end

  def campaign_costs(from, till)
    (from..till).step(10).map do |date_step_from|
      date_step_till = [date_step_from + 9, till].min

      sleep 1.5 # rate limit avoidance
      campaigns(date_step_from, date_step_till).map do |campaign|
        {
          :date        => Date.parse(campaign['logDate']),
          :campaign    => campaign['adgroup'],
          :adgroup     => campaign['adgroup'],
          :impressions => campaign['impressions'],
          :clicks      => campaign['clicks'],
          :conversions => campaign['conversions'],
          :amount      => campaign['price']
        }
      end
    end.flatten
  end
end
