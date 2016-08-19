class AdtekioAdnetworks::Cost::Mnectar
  include AdtekioAdnetworks::CostImport

  Endpoint = "http://api.mnectar.com/report/v1/advertiser/daily"
  Stepsize = 30

  def load_data(from, till)
    (from..till).step(Stepsize).map do |start_date|
      uri = Addressable::URI.parse(Endpoint)
      uri.query_values = {
        'advertiser-identifier' => credentials.advertiser_id,
        'token'                 => credentials.secret_key,
        'start-date'            => start_date.strftime("%Y-%m-%d"),
        'end-date'              => (start_date + Stepsize - 1).strftime("%Y-%m-%d"),
        'timezone'              => 'GMT',
      }

      req = Net::HTTP::Get.new(uri.request_uri)
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end

      JSON.parse(res.body, :symbolize_names => true)
    end.flatten
  end

  def campaign_costs(from, till)
    load_data(from, till).map do |row|
      next if row[:totalSpend].to_f == 0
      {
        :date         => Date.parse(row[:intervalDate]),
        :campaign     => row[:campaignName],
        :adgroup      => row[:adName],
        :impressions  => row[:impressions].to_i,
        :clicks       => row[:clicks].to_i,
        :conversions  => row[:conversions].to_i,
        :amount       => row[:totalSpend].to_f
      }
    end
  end
end
