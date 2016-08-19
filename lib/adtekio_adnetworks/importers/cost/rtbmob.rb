class AdtekioAdnetworks::Cost::Rtbcom
  include AdtekioAdnetworks::CostImport

  def csv_data(from, till)
    uri = Addressable::URI.parse("https://api.manage.com/1/stats.php")
    uri.query_values = {
      :advertiser_id  => credentials.advertiser_id,
      :advertiser_key => credentials.secret_key,
      :date_from      => from.strftime("%Y-%m-%d"),
      :date_to        => till.strftime("%Y-%m-%d"),
      :type           => "campaign",
      :break_by       => "date",
    }

    http = Net::HTTP::Persistent.new('rtbcom')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = http.request(URI.parse(uri.to_s))
    if request.code =~ /3../
      http.request(URI.parse(request.header["Location"])).body
    else
      request.body
    end
  end

  def campaign_costs(from, till)
    csv_options = {
      :col_sep    => ",",
      :quote_char => '"',
      :headers    => :first_row,
    }

    CSV.new(csv_data(from,till), csv_options).to_a.map do |row|
      {
        :date        => Date.strptime(row["date"], "%Y-%m-%d"),
        :campaign    => row['campaign'],
        :impressions => row['impression'].to_i,
        :clicks      => row['click'].to_i,
        :conversions => row['install'].to_i,
        :amount      => row["cost"].to_f,
      }
    end
  end
end
