class AdtekioAdnetworks::Revenue::Adcolony
  include AdtekioAdnetworks::RevenueImport

  CsvOptions = {
    :col_sep    => ",",
    :quote_char => '"',
    :headers    => :first_row,
  }

  BASE_URL = "https://clients.adcolony.com/api/v2/publisher_summary"

  def revenues(from, to)
    (from..to).map do |day|
      store = Hash.new {|h,k| h[k] = Hash.new { |h1,k1| h1[k1]=Hash.new(0)}}
      csv_data = csv_data(day)

      CSV(csv_data, CsvOptions).each do |row|
        next if zero_row?(row)
        hsh = store[row["App Name"]][row["Start Date"]]

        ["Earnings ($)", "Clicks", "Impressions", "Requests"].
          each do |colname|
          hsh[colname] += row[colname].to_f
        end
      end

      store.map do |title, data|
        data.map do |date, hsh|
          {
            :impressions => hsh["Impressions"].to_i,
            :requests    => hsh["Requests"].to_i,
            :clicks      => hsh["Clicks"].to_i,
            :amount      => hsh["Earnings ($)"].to_f,
            :date        => Date.strptime(date, "%Y-%m-%d"),
            :appname     => title
          }
        end
      end.flatten
    end.flatten
  end

  def report(from, to)
    (from..to).map do |day|
      csv_data(day)
    end
  end

  def zero_row?(csvrow)
    csvrow["Earnings ($)"] == "0" && csvrow["Impressions"] == "0"
  end

  def csv_data(date)
    uri = Addressable::URI.new
    uri.query_values = {
      :user_credentials => credentials.api_key,
      :date             => date.strftime("%m%d%Y"),
      :format           => 'csv',
    }
    datauri = URI.parse("%s?%s" % [BASE_URL, uri.query])

    Net::HTTP::Persistent.new('adcolony').request(datauri).body
  end
end
