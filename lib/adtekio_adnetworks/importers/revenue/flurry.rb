class AdtekioAdnetworks::Revenue::Flurry
  include AdtekioAdnetworks::RevenueImport

  def revenues(from, to)
    report(from, to).map do |data|
      data.map do |adspace_id, values|
        next if values.nil?
        values.map do |hsh|
          check_version!(hsh['@version'], "1.0")
          check_currency!(hsh["currency"], "usd")

          next if hsh["results"].nil?
          date = Date.strptime(hsh["results"]["date"], "%Y-%m-%d")

          # Kinda confusing since the data is duplicated for each
          # day. We import everything but flurry sends on a per-country
          # basis with then a global value. That means the total
          # of all entries for day with country should be the same
          # as the entry with country == null.
          ( (hsh["results"]["country_stats"] || []) +
            [hsh['results']["global_stats"]]).compact.map do |dpt|
            {
              :date        => date,
              :appname     => adspace_id,
              :country     => dpt["country"],
              :amount      => dpt["revenue"].to_f,
              :clicks      => dpt["clicks"].to_i,
              :impressions => dpt["impressions"].to_i,
              :installs    => dpt["installs"].to_i
            }
          end
        end
      end
    end.flatten.compact
  end

  def report(from,to)
    creds = credentials.keys["adspace_id"].zip(credentials.keys["api_key"])
    creds.map do |adspace_id, api_key|
      { adspace_id => ( (from..to).map do |date|
                          data_for_apikey(api_key, adspace_id, date)
                        end)
      }
    end
  end

  def data_for_apikey(key, adspaceid, for_date = Date.today-1)
    sdate, edate = [for_date, for_date+1].map { |a| a.strftime("%Y-%m-%d") }

    uri = Addressable::URI.new
    uri.query_values = {
      :apiAccessCode => credentials.access_code,
      :adSpaceId     => adspaceid,
      :apiKey        => key,
      :startDate     => sdate,
      :endDate       => edate
    }

    datauri = URI.
      parse("%s?%s" % ["http://api.flurry.com/ffp/v1/AdSpaceCountry",
                       uri.query])

    repeatthis(10) do
      JSON(Net::HTTP::Persistent.new('flurry').request(datauri).body)
    end
  end
end
