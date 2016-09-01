class AdtekioAdnetworks::Cost::Facebook
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:access_token]
  end

  def curlobj(urlstr)
    Curl::Easy.new.tap do |w|
      w.url = urlstr
      w.follow_location = false
      w.timeout = 10
    end
  end

  def campaign_costs(from, till)
    from.upto(till).map do |date|
      uri = Addressable::URI.
        parse("https://graph.facebook.com/act_#{credentials.account_id}/stats")
      uri.query_values = {
        :access_token => credentials.access_token,
        :start_time   => date.strftime("%s"),
        :end_time     => (date + 1).strftime("%s"),
      }
      (w = curlobj(uri.to_s)).perform
      JSON(w.body_str).merge(:date => date)
    end.flatten.group_by do |reports|
      reports[:date]
    end.map do |date, reports|
      {
        :date        => date,
        :impressions => reports.map{|v|v[:impressions]}.reduce(:+),
        :clicks      => reports.map{|v|v[:clicks]}.reduce(:+),
        :conversions => reports.map{|v|v[:conversions]}.reduce(:+),
        :amount      => reports.map{|v|v[:spent]}.reduce(:+)
      }
    end
  end
end
