class AdtekioAdnetworks::Revenue::Supersonic
  include AdtekioAdnetworks::RevenueImport

  BASE_URL = "https://api.supersonicads.com/api/rest/v1/ultra/statistics"

  def revenues(from, to)
    report(from,to).map do |(appname, appid, providerName, date), values|
      values.map do |dpt|
        # we assume: impressions == clicks, strange but true!
        if dpt.impressions != dpt.clicks
          raise "impressions didn't match clicks: "+
            "#{dpt.impressions}/#{dpt.clicks}"
        end

        nmstuff = {
          :provider        => providerName,
          :appid           => appid,
          :uniqUser        => dpt.uniqueUsers.remove(',').to_i,
          :uniqPayingUsers => dpt.uniquePayingUsers.remove(',').to_i,
          :rewards         => dpt.rewards.remove(',').to_i,
        }

        {
          :date        => Date.strptime(date, "%Y-%m-%d"),
          :appname     => appname,
          :amount      => dpt.revenue.remove('$').to_f,
          :requests    => dpt.hits.remove(',').to_i,
          :impressions => dpt.fulfillments.remove(',').to_i,
          :clicks      => dpt.clicks.remove(',').to_i,
          :completions => dpt.completions.remove(',').to_i,
          :not_matched => not_matched(nmstuff)
        }
      end
    end.flatten
  end

  def report(from,to)
    CSV(ultra_data(from,to), :col_sep => ",", :headers => true ).map do |a|
      OpenStruct.new(a.to_h)
    end[0..-2].group_by do |a| ## last line is a summary row, ignore it.
      [a.applicationName, a.applicationId, a.providerName, a.theDate]
    end
  end

  def http_client
    @http_client ||= Net::HTTP::Persistent.new('supersonic').tap do |client|
      client.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def ultra_data(from_date, to_date)
    http_client.request(ultra_url(from_date, to_date)).body
  end

  def ultra_url(from_date, to_date)
    uri = Addressable::URI.new
    uri.query_values = {
      :accessKey     => credentials.access_key,
      :secretKey     => credentials.secret_key,
      :onlyRevenue   => 0,
      :fromDate      => from_date.strftime("%Y-%m-%d"),
      :toDate        => to_date.strftime("%Y-%m-%d"),
      :format        => "csv",
      "breakdowns[]" => ["date", "application", "provider"]
    }

    URI.parse("%s?%s" % [BASE_URL, uri.query])
  end
end
