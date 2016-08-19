class AdtekioAdnetworks::Revenue::Tapsense
  include AdtekioAdnetworks::RevenueImport
  ## More info on the API:
  ## https://github.com/TapSense/tapsense-adapters/wiki/TapSense-Reporting-API-for-Publishers

  def revenues(from, to)
  end

  def report(from,to)
  end

  def data(from, to)
    require 'mechanize'
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'

    agent.post("https://dashboard.tapsense.com/console/login", {
                 :username   => credentials.username,
                 :password   => credentials.password}.to_json,
               {"Content-Type" => "application/json",
                 "Accept"      => "application/json" })

    uri = Addressable::URI.new
    uri.query_values = {
      :start_date  => from.strftime("%Y-%m-%d"),
      :end_date    => to.strftime("%Y-%m-%d"),
      :format      => :json,
      :rollup      => "date,country",
      :action_type => "report"
    }
    url = "https://dashboard.tapsense.com/console/publisher/report"
    agent.get("%s?%s" % [url, uri.query]).body
  end
end
