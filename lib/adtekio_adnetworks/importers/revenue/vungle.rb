class AdtekioAdnetworks::Revenue::Vungle
  include AdtekioAdnetworks::RevenueImport

  BASE_URL = "https://ssl.vungle.com"

  def revenues(from, to)
    report(from,to).map do |dpt|
      nmstuff = {
        :appId      => dpt['appId'],
        :installs   => dpt['installs'],
        :platform   => dpt['platform'],
        :status     => dpt['status'],
        :connection => dpt['connection']
      }

      {
        :appname     => dpt['name'],
        :date        => dpt['datestamp'],
        :amount      => dpt['revenue'].to_f,
        :impressions => dpt['impressions'].to_i,
        :clicks      => dpt['views'].to_i,
        :completions => dpt['completes'].to_i,
        :not_matched => not_matched(nmstuff)
      }
    end
  end

  def report(from,to)
    # Because we have a api rate limit of 2 per 10 seconds:
    #    ApiError: Rate limit hit. Maximum 2 requests every 10 seconds
    # batch the dates together and sleep 5 seconds between requests.
    applications.map do |app|
      sleep 5
      retrieve_data(app["id"], from, to).map do |data|
        data.merge(app).
          merge("datestamp" => Date.strptime(data["date"], "%Y-%m-%d"))
      end
    end.flatten
  end

  def applications
    uri = Addressable::URI.new
    uri.query_values = { :key => credentials.api_key }
    datauri = URI.
      parse("%s/api/applications?%s" % [BASE_URL, uri.query])

    JSON(Net::HTTP::Persistent.new('vungle').request(datauri).body)
  end

  def retrieve_data(app, startdate, enddate)
    uri = Addressable::URI.new
    uri.query_values = {
      :key   => credentials.api_key,
      :start => startdate.strftime("%Y-%m-%d"),
      :end   => enddate.strftime("%Y-%m-%d")
    }
    datauri = URI.
      parse("%s/api/applications/%s?%s" % [BASE_URL, app, uri.query])

    json_data_string =
      Net::HTTP::Persistent.new('vungle').request(datauri).body

    begin
      JSON(json_data_string)
    rescue Exception => e
      $stderr.puts("vungle data failure: #{e}")
      $stderr.puts("json data string: #{json_data_string}")
      []
    end
  end
end
