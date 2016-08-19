class AdtekioAdnetworks::Cost::Unilead
  include AdtekioAdnetworks::CostImport

  def campaign_costs(from, till)
    uri = Addressable::URI.
      parse("http://my.unileadnetwork.com/stats/stats.json")

    uri.query_values = {
      :api_key    => credentials.api_key,
      :start_date => from.to_s,
      :end_date   => till.to_s,
      :'group[]'  => ['Stat.date', 'Offer.name'],
      :'field[]'  => ['Stat.conversions', 'Stat.impressions', 'Stat.clicks', 'Stat.revenue'],
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    JSON.parse(res.body)['data'].map do |campaign|
      costs = campaign['cost'].gsub(/[^\d]/,'').to_f/100
      next if costs == 0.0

      {
        :date          => Date.strptime(campaign["date"], "%Y-%m-%d"),
        :campaign      => campaign["offer"],
        :impressions   => campaign['impressions'].to_i,
        :clicks        => campaign['clicks'].to_i,
        :conversions   => campaign["conversions"].to_i,
        :amount        => costs,
      }
    end
  end
end
