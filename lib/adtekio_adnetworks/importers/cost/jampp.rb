class AdtekioAdnetworks::Cost::Jampp
  include AdtekioAdnetworks::CostImport

  def campaigns(from, till)
    uri = Addressable::URI.parse("http://ruby.jampp.com/api/advertisers.json")
    uri.query_values = {
      "filter[from]" => from.strftime("%Y-%m-%d"),
      "filter[to]"   => till.strftime("%Y-%m-%d"),
    }

    req = Net::HTTP::Post.new(uri.request_uri)
    req.form_data = {:api_key => credentials.api_key}
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    JSON.parse(res.body)['data']
  end

  def campaign_details(campaign_id, from, till)
    uri = Addressable::URI.
      parse("http://ruby.jampp.com/api/advertisers/details/#{campaign_id}.json")
    uri.query_values = {
      "filter[from]" => from.strftime("%Y-%m-%d"),
      "filter[to]"   => till.strftime("%Y-%m-%d"),
    }

    req = Net::HTTP::Post.new(uri.request_uri)
    req.form_data = {:api_key => credentials.api_key}
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end

    JSON.parse(res.body)['data']
  end

  def campaign_costs(from, till)
    campaigns(from, till).map do |campaign|
      campaign_details(campaign["Campaign.id"], from, till).map do |metrics|
        campaign_name = campaign["Campaign.name"].gsub(' ','_').downcase

        {
          :date           => Date.parse(metrics['date']),
          :campaign       => campaign_name,
          :clicks         => metrics['clicks'].to_i,
          :conversions    => metrics['installs'].to_i,
          :amount         => metrics['cost'].gsub(', ', '').to_f,
          :target_country => campaign["Country.code"].downcase,
        }
      end
    end.flatten
  end
end
