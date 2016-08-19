class AdtekioAdnetworks::Cost::Glispa
  include AdtekioAdnetworks::CostImport

  def csv_data(from, till)
    uri = Addressable::URI.
      parse("https://www.glispainteractive.com/API/advreport.php")

    uri.query_values = {
      :cid      => credentials.cid,
      :token    => credentials.token,
      :bdate    => from.strftime("%Y-%m-%d"),
      :edate    => till.strftime("%Y-%m-%d"),
      :format   => :csv
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end

    CSV.new(res.body.rstrip, :headers => :first_line, :col_sep => ";")
  end

  def parse_glispa_name(glispa_name)
    app_name, platform, adgroup, *ad = glispa_name.downcase.split(' - ')

    ad.compact!
    country = adgroup.length == 2 ? adgroup : nil
    campaign = if ad.size == 1 && ad.join(" ") != 'gNative'
                 ad.first
               else
                 "#{country}_#{platform}"
               end
    ["", campaign, adgroup, ad.join(" "), country]
  end

  def campaign_costs(from, till)
    csv_data(from, till).map do |row|
      glispa_name = row["Campaign Name"]
      _, campaign, adgroup, ad, country = parse_glispa_name(glispa_name)

      next if row["Payout"].to_f == 0.0

      {
        :campaign       => campaign,
        :adgroup        => adgroup,
        :ad             => ad,
        :amount         => row["Revenue"].to_f,
        :date           => Date.parse(row["Date"]),
        :target_country => country,
      }
    end.compact
  end
end
