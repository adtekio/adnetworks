class AdtekioAdnetworks::Cost::Appia
  include AdtekioAdnetworks::CostImport

  def campaign_costs(from, till)
    uri = Addressable::URI.
      parse("https://via.appia.com/pss/api/report/advertiser/performance.json")

    uri.query_values = {
      :startDate => from.strftime("%Y-%m-%d"),
      :endDate   => till.strftime("%Y-%m-%d"),
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth credentials.username, credentials.password

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end

    results = JSON.parse(res.body, :symbolize_names => true)
    results[:performance][:campaigns].map do |campaign|
      campaign[:days].map do |metrics|

        clicks =
          metrics[:tiers].map {|tier| tier[:clickCount].to_i}.inject(:+)
        installs =
          metrics[:tiers].map {|tier| tier[:installCount].to_i}.inject(:+)
        spends = metrics[:tiers].map {|tier| tier[:spend].to_f}.inject(:+)

        next if spends.to_f == 0

        {
          :date        => Date.parse(metrics[:date]),
          :campaign    => campaign[:campaignName],
          :clicks      => clicks,
          :conversions => installs,
          :amount      => spends,
        }
      end.compact
    end.flatten
  end
end
