class AdtekioAdnetworks::Cost::Mobpartner
  include AdtekioAdnetworks::CostImport

  def campaign_costs(from, till)
    uri = Addressable::URI.
      parse("http://reportapiv2.mobpartner.mobi/report2.php")

    uri.query_values = {
      :login              => credentials.login,
      :key                => credentials.api_key,
      :date_type          => :daily,
      :date_begin         => from.strftime("%Y%m%d"),
      :date_end           => till.strftime("%Y%m%d"),
      :campaign           => :ALL,
      :clicks             => 1,
      :imps               => 1,
      :nb_trx_notrefused  => 1,
      :default_values     => 0,
      :display_name       => 1,
      :download           => 1,
      :format             => :csv,
      :date_format        => 2,
      :value_trx_notrefused_total => 1,
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    CSV.parse(res.body, {:col_sep => ";"}).drop(1).map do |row|
      {
        :date        => Date.parse(row[0]),
        :campaign    => row[2],
        :impressions => row[3].to_i,
        :clicks      => row[4].to_i,
        :conversions => row[5].to_i,
        :amount      => row[6].to_f,
      }
    end
  end
end
