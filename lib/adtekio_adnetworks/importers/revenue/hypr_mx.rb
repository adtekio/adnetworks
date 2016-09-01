class AdtekioAdnetworks::Revenue::HyprMx
  include AdtekioAdnetworks::RevenueImport

  BASE_URL = 'https://live.hyprmx.com/fyber/v1/'

  define_required_credentials do
    [:apps]
  end

  def revenues(from, to)
    # We import everything but hypermx sends on a per-country
    # basis with then a global value. That means the total
    # of all entries for day with country should be the same
    # as the entry with country == null, for a specific date.
    report(from,to).map do |dpt|
      ((dpt[:country_stats] || []) + [dpt[:global_stats]]).map do |stats|
        {
          :appname     => dpt[:appname],
          :date        => dpt[:date],
          :amount      => stats[:revenue].to_f,
          :impressions => stats[:impressions].to_i,
          :completions => stats[:completions].to_i,
          :country     => stats[:country],
          :not_matched => not_matched(:dist_id => dpt[:dist_id])
        }
      end
    end.flatten.compact
  end

  def report(from,to)
    cnt = (credentials.apps["dist_id"] || []).count

    cnt.times.map do |idx|
      data = load_data({ :app_id       => credentials.apps["dist_id"][idx],
                         :placement_id => credentials.apps["placement_id"][idx],
                         :start_date   => from.to_s,
                         :end_date     => to.to_s,
                       }, credentials.apps["api_key"][idx])

      check_currency!(data[:currency], "usd")

      data[:results].map do |dpt|
        dpt.merge({ :appname => credentials.apps["placement_id"][idx],
                    :date    => Date.strptime(dpt[:date],"%Y-%m-%d"),
                    :dist_id => credentials.apps["dist_id"][idx]})
      end
    end.flatten.compact
  end

  def http_client
    @http_client ||= Net::HTTP::Persistent.new('hyprmx').tap do |client|
      client.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def hash(params, api_key)
    value = Hash[params.sort_by{|k, _| k}].map do |k,v|
      "#{k}=#{v}"
    end.join('&') + "&" + api_key
    Digest::SHA1.hexdigest value
  end

  def load_data(params, api_key)
    uri = Addressable::URI.parse(BASE_URL)
    uri.query_values = params.merge({:hash_value => hash(params, api_key)})
    response = http_client.request(URI.parse(uri.to_s))
    JSON(response.body, :symbolize_names => true)
  end
end
