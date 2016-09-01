class AdtekioAdnetworks::Cost::Loopme
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:api_key]
  end

  def load_data(from, till)
    from.upto(till).map do |date|
      uri = Addressable::URI.
        parse("http://reports.loopme.me/api/v1/reports/campaigns")

      uri.query_values = {
        :group_by       => 'line_item',
        :api_auth_token => credentials.api_key,
        :date_range     => ("%s:%s" % [date, date].map do |d|
                              d.strftime("%Y-%m-%d")
                            end),
      }

      req = Net::HTTP::Get.new(uri.request_uri)
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end

      # follow one redirect.
      body = if res.code =~ /3../
               uri = Addressable::URI.parse(res.header["Location"])
               req = Net::HTTP::Get.new(uri.request_uri)
               Net::HTTP.start(uri.host, uri.port) do |http|
                 http.request(req)
               end.body
             else
               res.body
             end

      JSON.parse(body)['series'].map do |serie|
        serie['date'] = date
        serie
      end
    end.compact.flatten
  end

  def campaign_costs(from, till)
    # the campaign names where invalid before this date and on the same time
    # we have correct manual cost before this date
    invalid_before = Date.parse('2014-08-01')
    return [] if till <= invalid_before
    from = [from, invalid_before].max

    load_data(from, till).map do |campaign|
      puts campaign
      {
        :date        => campaign['date'],
        :campaign    => campaign['line_item'],
        :impressions => campaign['totals']['Views'].gsub(',    ', '').to_i,
        :clicks      => campaign['totals']['Clicks'].gsub(',   ', '').to_i,
        :conversions => campaign['totals']['Installs'].gsub(',     ', '').to_i,
        :amount      => campaign['totals']['Spend, $'].gsub(', ', '').to_f
      }
    end
  end
end
