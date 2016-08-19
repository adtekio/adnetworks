class AdtekioAdnetworks::Cost::Bidmotion
  include AdtekioAdnetworks::CostImport

  API_ENDPOINT = 'http://api.mobdone.com/api/v1/'
  AUTH_ROUTE   = 'session'
  DATA_ROUTE   = 'reports'

  EXPECTED_ARRAY_ORDER = ["click_date", "offer_numeric_id", "country_code",
                          "device_type", "clicks", "conversions",
                          "conversion_rate", "revenue"]

  def campaign_costs(from, till)
    load_data(from, till).reject do |campaign_data|
      campaign_data[7].to_f == 0
    end.map do |campaign_data|
      country_code  = campaign_data[2].downcase
      device        = campaign_data[3].downcase
      campaign_name = "#{country_code}_#{device}"

      {
        :date           => Date.parse(campaign_data[0]),
        :campaign       => campaign_name,
        :clicks         => campaign_data[4].to_i,
        :conversions    => campaign_data[5].to_i,
        :amount         => campaign_data[7].to_f,
        :target_country => country_code,
        :target_device  => device
      }
    end
  end

  private

  def session_id
    @session_id ||= begin
                      uri = URI("#{API_ENDPOINT}#{AUTH_ROUTE}")
                      params = {
        :user_username => credentials.username,
        :user_password => credentials.password,
        :platform_name => credentials.platform
      }

                      response = Net::HTTP.post_form(uri, params) do |http|
        http.request(req)
      end

                      response_json =
                        JSON.parse(response.body, :symbolize_names => true)
                      response_json[:session_id]
                    end
  end

  def load_data(from, till)
    uri = Addressable::URI.parse("#{API_ENDPOINT}#{DATA_ROUTE}")
    uri.query_values = {
      :group_by      => "click_date,offer_numeric_id,country_code,device_type,",
      :click_date_init  => from.to_s,
      :click_date_end   => till.to_s
    }

    request = Net::HTTP::Get.new(uri.request_uri)
    request["X-Session-Id"] = session_id

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end

    response_json = JSON.parse(response.body, :symbolize_names => true)

    raise "wrong field order: #{response_json[:fields]}" unless valid_field_order?(response_json[:fields])

    response_json[:rows]
  end

  def valid_field_order?(response_fields)
    response_fields == EXPECTED_ARRAY_ORDER
  end
end
