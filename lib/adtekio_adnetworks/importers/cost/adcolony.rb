class AdtekioAdnetworks::Cost::Adcolony
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:api_key]
  end

  def campaign_costs(from, till)
    uri = Addressable::URI.
      parse("http://clients.adcolony.com/api/v2/advertiser_summary")

    uri.query_values = {
      :user_credentials  => credentials.api_key,
      :date       => from.strftime("%m%d%Y"),
      :end_date   => till.strftime("%m%d%Y"),
      :group_by   => [:campaign, :ad_group, :country],
      :date_group => :day
    }
    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    (JSON.parse(res.body, :symbolize_names => true)[:results] || []).
      map do |campaign|
      next if campaign[:spend].to_f == 0.0
      campaign_name = campaign[:group_name].
        encode(Encoding.find('ASCII'),
               :invalid => :replace, :replace => '', :undef   => :replace)

      {
        :date         => Date.strptime(campaign[:date], "%Y-%m-%d"),
        :campaign     => campaign_name,
        :adgroup      => campaign[:country],
        :impressions  => campaign[:impressions].to_i,
        :clicks       => campaign[:total_clicks].to_i,
        :conversions  => campaign[:installs].to_i,
        :amount       => campaign[:spend].to_f,
        :target_country => campaign[:country].try(:downcase),
      }
    end
  end
end
