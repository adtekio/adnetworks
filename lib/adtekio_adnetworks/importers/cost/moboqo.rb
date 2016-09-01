class AdtekioAdnetworks::Cost::Moboqo
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:api_key]
  end

  def campaign_costs(from, till)
    uri = Addressable::URI.parse("http://dashboard.moboqo.com/stats/stats.json")
    uri.query_values = {
      :api_key    => credentials.api_key,
      :start_date => from.strftime("%Y-%m-%d"),
      :end_date   => till.strftime("%Y-%m-%d"),
      "group[0]"   => "Stat.date",
      "group[1]"   => "Offer.name",
    }

    req = Net::HTTP::Get.new(uri.request_uri)

    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    JSON.parse(res.body)['data'].map do |datapoint|
      {
        :date        => Date.strptime(datapoint["date"], "%Y-%m-%d"),
        :campaign    => datapoint["offer"],
        :conversions => datapoint['conversions'].to_i,
        :amount      => datapoint['cost'].gsub(/\$/, '').to_f
      }
    end
  end
end
