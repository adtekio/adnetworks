class AdtekioAdnetworks::Cost::Applift
  include AdtekioAdnetworks::CostImport

  DateSteps = 5

  def campaign_costs(from, till)
    from.step(till, DateSteps).map do |start_date|
      end_date = [start_date + DateSteps - 1, till].min
      uri = Addressable::URI.
        parse("https://partner.applift.com/stats/stats.json")

      uri.query_values = {
        :api_key     => credentials.api_key,
        :start_date  => start_date.strftime("%Y-%m-%d"),
        :end_date    => end_date.strftime("%Y-%m-%d"),
        'group[]'    => ["Offer.name", "Stat.date"]
      }

      req = Net::HTTP::Get.new(uri.request_uri)
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                            :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        http.request(req)
      end

      JSON.parse(res.body)['data'].reject do |campaign|
        campaign["cost"] == "$0.00" || campaign["offer"].blank?
      end.map do |campaign|
        {
          :date         => Date.parse(campaign['date']),
          :campaign     => campaign['offer'].gsub(/(, private)/i,'').gsub(/( private)/i,'').gsub(/(, rtl2 private)/i,''),
          :conversions  => campaign['conversions'].to_i,
          :amount       => campaign['cost'].tr(',$','').to_f
        }
      end
    end.flatten
  end
end
