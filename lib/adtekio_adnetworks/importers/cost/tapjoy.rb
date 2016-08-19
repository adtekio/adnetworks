class AdtekioAdnetworks::Cost::Tapjoy
  include AdtekioAdnetworks::CostImport

  def campaign_costs(from, till)
    from.upto(till).map do |date|

      uri = Addressable::URI.
        parse("https://api.tapjoy.com/reporting_data.json")

      uri.query_values = {
        :email    => credentials.username,
        :api_key  => credentials.api_key,
        :date     => date.strftime('%Y-%m-%d'),
        :timezone => 0
      }

      req = Net::HTTP::Get.new(uri.request_uri)
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,
                            :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        http.request(req)
      end

      JSON.parse(res.body, :symbolize_names => true)
    end.map do |report|
      report[:Apps].map do |campaign|
        next if campaign[:Spend].to_f == 0
        next if campaign[:Name] =~ /free/i
        {
          :date        => Date.parse(report[:Date]),
          :campaign    => campaign[:Name],
          :clicks      => campaign[:PaidClicks].to_i,
          :conversions => campaign[:PaidInstalls].to_i,
          :amount      => campaign[:Spend].to_f.abs
        }
      end
    end.flatten
  end
end
