class AdtekioAdnetworks::Revenue::Mdotm
  include AdtekioAdnetworks::RevenueImport

  define_required_credentials do
    [:account_id, :secret_key]
  end

  def revenues(from, to)
    report(from, to).map do |data|
      {
        :impressions => data["impressions"].to_i,
        :requests    => data["requests"].to_i,
        :clicks      => data["clicks"].to_i,
        :amount      => data["earnings"].to_f,
        :date        => Date.strptime(data["logDT"], "%Y-%m-%d"),
        :appname     => data["appname"]
      }
    end
  end

  def report(from,to)
    url = "http://platform.mdotm.com/monetize/appstats/" +
      credentials.account_id.to_s + "/" +
      credentials.secret_key.to_s + "/" +
      from.strftime("%Y-%m-%d") + "/" +
      to.strftime("%Y-%m-%d")

    JSON(do_request(url))
  end

  def do_request(url)
    h = Net::HTTP::Persistent.new('whatever')
    h.verify_mode = OpenSSL::SSL::VERIFY_NONE
    uri = URI.parse(url)
    req = Net::HTTP::Get.new uri.request_uri
    h.request(uri,req).body
  end
end
