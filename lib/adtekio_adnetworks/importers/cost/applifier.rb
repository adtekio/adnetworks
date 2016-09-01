class AdtekioAdnetworks::Cost::Applifier
  include AdtekioAdnetworks::CostImport

  DateSteps = 5

  define_required_credentials do
    [:api_key]
  end

  def csv_data(from, till)
    uri = Addressable::URI.
      parse("https://gameads-admin.applifier.com/stats/acquisition-api")

    uri.query_values = {
      :apikey  => credentials.api_key,
      :scale   => "day",
      :start   => from.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
      :end     => till.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
      :fields  => "views,clicks,installs,spend",
      :splitBy => "campaign,country",
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end

    if res.code =~ /3../
      uri = Addressable::URI.parse(res.header["Location"])
      req = Net::HTTP::Get.new(uri.request_uri)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                      :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        http.request(req)
      end.body
    else
      res.body
    end
  end

  def campaign_costs(from,till)
    csv_options = {
      :col_sep    => ",",
      :quote_char => '"',
      :headers    => :first_row,
    }

    from.step(till, DateSteps).map do |start_date|
      end_date = [start_date + DateSteps, till].min
      CSV.new(csv_data(start_date, end_date), csv_options).to_a.map do |row|
        country = row["Country code"].try(:downcase)
        {
          :date         => Date.strptime(row["Date"], '%Y-%m-%d'),
          :campaign     => row["Target name"],
          :impressions  => row["views"].to_i,
          :clicks       => row['clicks'].to_i,
          :conversions  => row['installs'].to_i,
          :amount       => row['spend'].to_f,
          :target_country => country[0..1],
        }
      end.compact
    end.flatten
  end
end
