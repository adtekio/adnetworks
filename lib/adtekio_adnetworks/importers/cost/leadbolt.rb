class AdtekioAdnetworks::Cost::Leadbolt
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:advertiser_id, :secret_key]
  end

  def load_data(from, till)
    return [] if till < Date.today-7
    from = [Date.today-7, from].max
    uri = Addressable::URI.
      parse("https://www.leadbolt.net/api/advertiser_report")

    uri.query_values = {
      :advertiser_id  => credentials.advertiser_id,
      :secret_key     => credentials.secret_key,
      :format         => :json,
      :date_from      => from.strftime("%Y%m%d"),
      :date_to        => till.strftime("%Y%m%d"),
    }
    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    JSON(res.body, :symbolize_names => true).first[:data]
  end

  def campaign_costs(from, till)
    load_data(from, till).reject do |campaign|
      campaign[:spend].to_f == 0.0
    end.map do |campaign|
      {
        :date        => Date.parse(campaign[:date]),
        :campaign    => campaign[:campaign_name],
        :impressions => campaign[:impressions].to_i,
        :clicks      => campaign[:clicks].to_i,
        :conversions => campaign[:conversions].to_i,
        :amount      => campaign[:spend].to_f
      }
    end
  end
end
