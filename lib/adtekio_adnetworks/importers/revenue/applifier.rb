class AdtekioAdnetworks::Revenue::Applifier
  include AdtekioAdnetworks::RevenueImport

  CsvOptions = {
    :col_sep    => ",",
    :quote_char => '"',
    :headers    => :first_row,
  }

  BASE_URL = "https://gameads-admin.applifier.com/stats/monetization-api"

  define_required_credentials do
    [:api_key]
  end

  def revenues(from, to)
    report(from,to).map do |csv_data|
      CSV(csv_data, CsvOptions).map do |row|
        {
          :impressions => row["views"].to_i,
          :amount      => row["revenue"].to_f,
          :date        => Date.strptime(row["Date"], "%Y-%m-%d"),
          :appname     => row["Source game name"]
        }
      end
    end.flatten
  end

  def report(from,to)
    (from..to).map do |day|
      csv_data(day)
    end
  end

  def csv_data(date)
    uri = Addressable::URI.new
    uri.query_values = {
      :apikey  => credentials.api_key,
      :start   => date.strftime("%Y-%m-%d"),
      :end     => (date+1).strftime("%Y-%m-%d"),
      :fields  => 'views,revenue',
      :splitBy => 'source'
    }
    datauri = URI.parse("%s?%s" % [BASE_URL, uri.query])

    # follow one redirect.
    request = Net::HTTP::Persistent.new('applifier').request(datauri)
    if request.code =~ /3../
      Net::HTTP::Persistent.new('applifier').
        request(URI.parse(request.header["Location"])).body
    else
      request.body
    end
  end
end
