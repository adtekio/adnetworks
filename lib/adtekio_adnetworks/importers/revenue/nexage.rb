class AdtekioAdnetworks::Revenue::Nexage
  include AdtekioAdnetworks::RevenueImport

  def revenues(from, to)
    []
  end

  def report(from,to)
    []
  end

  def seller_revenue_by_app(from,to)
    Hash[site_ids(from,to)["detail"].map do |site_data|
           uri = Addressable::URI.new
           uri.query_values = {
             :start => from.strftime("%Y-%m-%d"),
             :stop  => to.strftime("%Y-%m-%d"),
             :dim   => "day",
             :site  => site_data["siteId"]
           }
           url = ("https://reports.nexage.com/access/"+
                  "#{credentials.company_id}"+
                  "/reports/sellerrevenue")

           [site_data["site"],
            do_request("%s?%s" % [url, uri.query])["detail"]]
         end]
  end

  def site_ids(from,to)
    uri = Addressable::URI.new
    uri.query_values = {
      :start => from.strftime("%Y-%m-%d"),
      :stop  => to.strftime("%Y-%m-%d"),
      :dim   => "site"
    }
    url = ("https://reports.nexage.com/access/#{credentials.company_id}"+
           "/reports/sellerrevenue")
    do_request("%s?%s" % [url, uri.query])
  end

  def do_request(urlstring)
    digest_auth = Net::HTTP::DigestAuth.new

    uri = URI.parse(urlstring)
    uri.user = credentials.access_key
    uri.password = credentials.secret_key

    h = Net::HTTP::Persistent.new('whatever')
    h.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new uri.request_uri

    res = h.request uri, req

    auth = digest_auth.auth_header uri, res['www-authenticate'], 'GET'

    req = Net::HTTP::Get.new uri.request_uri
    req.add_field 'Authorization', auth

    res = h.request uri,req

    raise "No data available" if res.code.to_i == 204
    raise "Unable to authenticate" if res.code.to_i != 200
    JSON(res.body)
  end
end
