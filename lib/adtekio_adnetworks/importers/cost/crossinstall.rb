class AdtekioAdnetworks::Cost::Crossinstall
  include AdtekioAdnetworks::CostImport

  def campaign_costs(from, till)
    uri = Addressable::URI.parse("http://api.crossinstall.com/api/revenue")
    uri.query_values = {
      :email      => credentials.username,
      :api_key    => credentials.api_key,
      :start_date => from.strftime("%Y-%m-%d"),
      :end_day    => till.strftime("%Y-%m-%d")
    }
    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    ad_data = JSON.parse(res.body)["response"]["ads"].map do |ad_data|
      ad_data["stats"].map do |stat|
        next if stat["cost"].to_f == 0
        {
          :date        => Date.strptime(stat["day"], "%Y-%m-%d"),
          :campaign    => ad_data["name"],
          :clicks      => stat["clicks"].to_i,
          :conversions => stat["conversions"].to_i,
          :amount      => stat["cost"].to_f
        }
      end
    end.flatten
  end
end
