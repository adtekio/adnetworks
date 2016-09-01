class AdtekioAdnetworks::Revenue::Lifestreet
  include AdtekioAdnetworks::RevenueImport

  define_required_credentials do
    [:username, :password]
  end

  def revenues(from, to)
    add_global_stats(from, to).map do |(date, appname), values|
      values.map do |dpt|
        {
          :appname     => appname,
          :date        => Date.strptime(date, "%Y-%m-%d"),
          :country     => dpt["Country.name"],
          :impressions => dpt["adImps"].to_i,
          :amount      => dpt["adCost"].to_f
        }
      end
    end.flatten
  end

  def add_global_stats(from, to)
    # report comes split by country without a summary entry
    # over all countries, so add this summary.
    Hash[report(from,to)["data"].
         group_by { |a| [a["Date"], a["AdSlot.name"]] }.
         map do |(date, appname), values|
           [ [date,appname], values +
             [{ "Date"         => date,
                "AdSlot.name"  => appname,
                "Country.name" => nil,
                "adImps"       => values.map{ |a| a["adImps"] }.sum,
                "adCost"       => values.map{ |a| a["adCost"] }.sum }]]
         end]
  end

  def report(from, to)
    uri = Addressable::URI.
      parse("https://my.lifestreetmedia.com/reporting/run/")
    request = Net::HTTP::Post.new uri.request_uri
    request.basic_auth credentials.username, credentials.password
    # body is cgi encoded parameter with json values.
    request.body = "data=" + ({
                                "measurements" => ["adImps", "adCost"],
                                "dimensions"   => ["Date", "AdSlot.name",
                                                   "Country.name"],
                                "start_date" => from.to_s,
                                "end_date"   => to.to_s,
                                "mobile"     => true
                              }.to_json)

    http = Net::HTTP.new(uri.hostname, 443)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true

    response = http.request(request)
    JSON.parse(response.body)
  end
end
