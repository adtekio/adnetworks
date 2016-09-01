class AdtekioAdnetworks::Cost::Chartboost
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:user_id, :signature]
  end

  def campaign_costs(from, till)

    uri = Addressable::URI.
      parse("https://analytics.chartboost.com/v3/metrics/campaign")

    uri.query_values = {
      :userId        => credentials.user_id,
      :userSignature => credentials.signature,
      :dateMin       => from.strftime("%Y-%m-%d"),
      :dateMax       => till.strftime("%Y-%m-%d"),
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end
    raise 'could not load report' if res.code.to_i != 200

    JSON(res.body).reject do |a|
      a["moneySpent"].to_f == 0.00
    end.map do |campaign|
      {
        :date        => Date.parse(campaign['dt']),
        :campaign    => campaign["campaign"],
        :adgroup     => :banner,
        :impressions => campaign['impressionsReceived'].to_i,
        :clicks      => campaign['clicksReceived'].to_i,
        :conversions => campaign['installReceived'].to_i,
        :amount      => campaign['moneySpent'].to_f
      }
    end.compact
  end
end
