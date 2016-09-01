class AdtekioAdnetworks::Revenue::Chartboost
  include AdtekioAdnetworks::RevenueImport

  BASE_URL = "https://analytics.chartboost.com/queue/app"

  define_required_credentials do
    [:user_id, :signature]
  end

  def revenues(from, to)
    report(from,to).map do |hsh|
      {
        :impressions => hsh["impressionsDelivered"].to_i,
        :amount      => hsh["moneyEarned"].to_f,
        :date        => Date.strptime(hsh["dt"], "%Y-%m-%d"),
        :appname     => hsh["app"],
        :not_matched => not_matched(:platform    => hsh["platform"],
                                    :appBundleId => hsh["appBundleId"],
                                    :appId       => hsh["appId"])
      }
    end
  end

  def report(from, to)
    JSON(Net::HTTP::Persistent.new('chartboost').
         request(query_url(from,to)).body)
  end

  def query_url(from, to)
    params = {
      :userId        => credentials.user_id,
      :userSignature => credentials.signature,
      :dateMin       => from.strftime("%Y-%m-%d"),
      :dateMax       => to.strftime("%Y-%m-%d"),
      :groupBy       => :app,
      :aggregate     => :daily,
    }

    uri = Addressable::URI.new
    uri.query_values = params
    URI.parse("%s?%s" % [BASE_URL, uri.query])
  end
end
