class AdtekioAdnetworks::Revenue::Fyber
  include AdtekioAdnetworks::RevenueImport

  REPORT_URL =
    "https://dashboard.fyber.com/publishers/v1/28839/statistics.json"

  define_required_credentials do
    [:key]
  end

  def revenues(from, to)
    report(from,to).map do |dpt|
      appname = dpt['readable'].strip
      from.upto(to).each_with_index.map do |date, idx|
        {
          :completions => dpt["transactions"][idx].to_i,
          :impressions => dpt["views"][idx].to_i,
          :clicks      => dpt["clicks"][idx].to_i,
          :amount      => dpt["payout_usd"][idx].to_f,
          :date        => date,
          :appname     => appname,
          :not_matched => not_matched(:id => dpt["id"])
        }
      end
    end.flatten.compact
  end

  def report(from,to)
    load_data({
                :start_date         => from.to_s,
                :end_date           => to.to_s,
                :group_by           => :applications,
                :aggregation_level  => :days,
              })
  end

  def hash(params)
    value = Hash[params.sort_by{|k, _| k}].reject do |_,v|
      v.to_s.blank?
    end.map do |k,v|
      "#{k}=#{v}"
    end.inject("/publishers/v1/28839/statistics.json") do |string, param|
      string + "&" + param
    end + "&" + credentials.key

    Digest::SHA1.hexdigest value
  end

  def load_data(params)
    uri = Addressable::URI.parse(REPORT_URL)
    uri.query_values = params.merge({:hashkey => hash(params)})
    response = http_client.request(URI.parse(uri.to_s))
    JSON(response.body)['applications']
  end

  def http_client
    @http_client ||= Net::HTTP::Persistent.new('fyber').tap do |client|
      client.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end
end
