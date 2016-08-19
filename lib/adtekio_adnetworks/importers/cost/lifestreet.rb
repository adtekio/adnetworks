class AdtekioAdnetworks::Cost::Lifestreet
  include AdtekioAdnetworks::CostImport

  def campaign_costs(from, till)
    uri = Addressable::URI.
      parse("https://my.lifestreetmedia.com/reporting/run/")

    req = Net::HTTP::Post.new(uri.request_uri)
    req.form_data = {:data => {
        :measurements => {
          :Impressions => :adImps,
          :Conversions => :adConvs,
          :Cost        => :adRevenue,
          :Clicks      => :adClicks,
        },
        :dimensions => {
          :Date       => :Date,
          :Campaign   => "Campaign.name",
          :Country    => :Country
        },
        :start_date   => from.strftime("%Y-%m-%d"),
        :end_date     => till.strftime("%Y-%m-%d"),
      }.to_json}

    req.basic_auth credentials.username, credentials.password

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end

    JSON.parse(res.body)["data"].map do |values|
      {
        :date        => Date.parse(values["Date"]),
        :campaign    => values["Campaign.name"],
        :adgroup     => values["Country"],
        :impressions => values["adImps"].to_i,
        :clicks      => values["adClicks"].to_i,
        :conversions => values["adConvs"].to_i,
        :amount      => values["adRevenue"].to_f,
        :target_country => values["Country"]
      }
    end
  end
end
