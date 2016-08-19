class AdtekioAdnetworks::Cost::Revmob
  include AdtekioAdnetworks::CostImport

  def campaign_costs(from, till)
    url = "https://www.revmobmobileadnetwork.com/api/v1/users"+
      "/#{credentials.user_id}/auth/#{credentials.auth_token}/campaigns"+
      "/report.json"

    uri = Addressable::URI.parse(url)
    uri.query_values = {
      :startDate    => from.strftime("%Y-%m-%d"),
      :endDate      => till.strftime("%Y-%m-%d"),
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end
    raise 'could not load report' if res.code.to_i != 200

    campaigns = JSON(res.body)["campaigns"]
    campaigns.reject! do |camp|
      camp["daily_activities"].detect {|x| x["spend"].to_f > 0}.nil?
    end

    campaigns.map do |camp|
      camp["daily_activities"].map do |d|
        {
          :campaign    => camp["name"],
          :date        => Date.parse(d["day"]),
          :impressions => d["impressions"].to_i,
          :clicks      => d["clicks"].to_i,
          :conversions => d["installs"].to_i,
          :amount      => d["spend"].to_f
        }
      end
    end.flatten.compact
  end
end
