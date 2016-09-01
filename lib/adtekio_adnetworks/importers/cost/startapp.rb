class AdtekioAdnetworks::Cost::Startapp
  include AdtekioAdnetworks::CostImport

  ApiEndpoint = "http://api.startapp.com/adv/report/1.0"

  define_required_credentials do
    [:partner, :token]
  end

  def load_campaigns(from, till)
    uri = Addressable::URI.parse(ApiEndpoint)
    uri.query_values = {
      :partner    => credentials.partner,
      :token      => credentials.token,
      :startDate  => from.strftime("%Y%m%d"),
      :endDate    => till.strftime("%Y%m%d"),
      :dimension  => 'date,campaignId,country'
    }

    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    JSON.parse(res.body, :symbolize_names => true)[:data]
  end

  def campaign_costs(from, till)
    load_campaigns(from, till).map do |campaign|
      next if campaign[:spent].to_f == 0.0

      country = campaign[:country].try(&:downcase)
      country = nil if country == 'unknown'

      {
        :date           => Date.strptime(campaign[:date].to_s, "%Y%m%d"),
        :campaign       => campaign[:campaignName],
        :adgroup        => country,
        :target_country => country == 'unknown' ? nil : country,
        :impressions    => campaign[:impressions].to_i,
        :clicks         => campaign[:clicks].to_i,
        :conversions    => campaign[:installs].to_i,
        :amount         => campaign[:spent].to_f
      }
    end.compact
  end
end
