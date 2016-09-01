class AdtekioAdnetworks::Revenue::Mopub
  include AdtekioAdnetworks::RevenueImport

  define_required_credentials do
    [:account, :key]
  end

  def revenues(from, to)
    # index meanings can be taken from exp_cols
    report(from,to).map do |row|
      {
        :appname     => row[1],
        :date        => Date.strptime(row[0], "%Y-%m-%d"),
        :impressions => row[3],
        :requests    => row[4].to_i,
        :clicks      => row[5],
        :amount      => row[6]
      }
    end
  end

  def report(from,to)
    d = data(from,to)
    raise "Columns mismatch: #{d['columns']}" if d['columns'] != exp_cols
    d["rows"]
  end

  def exp_cols
    ["date", "app", "conversions", "impressions", "attempts",
     "clicks", "revenue"]
  end

  def http_client
    Net::HTTP::Persistent.new('chartboost').tap do |h|
      h.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def data(from,to)
    params = {
      :group_by   => "date,app",
      :start_date => from.strftime("%Y-%m-%d"),
      :end_date   => to.strftime("%Y-%m-%d"),
      :account    => credentials.account,
      :key        => credentials.key,
    }

    uri = Addressable::URI.new
    uri.query_values = params
    url = URI.parse("%s?%s" % ["https://data-service.mopub.com/mpx",
                               uri.query])
    JSON(http_client.request(url).body)
  end
end
