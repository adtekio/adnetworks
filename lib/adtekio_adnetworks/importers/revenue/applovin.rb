class AdtekioAdnetworks::Revenue::Applovin
  include AdtekioAdnetworks::RevenueImport

  BaseUrl = "https://r.applovin.com/report"
  ReportColumns = "application,platform,package_name,revenue,day,impressions,clicks,ad_type"

  def revenues(from, to)
    report(from, to).map do |(package, ad_type, date), values|
      osv = values.map{ |a| OpenStruct.new(a) }

      {
        :impressions => osv.map(&:impressions).map(&:to_i).sum,
        :clicks      => osv.map(&:clicks).map(&:to_i).sum,
        :amount      => osv.map(&:revenue).map(&:to_f).sum,
        :date        => date,
        :appname     => package,
        :not_matched => not_matched(:ad_type => ad_type,
                                    :platform => osv.map(&:platform).join(","))
      }
    end
  end

  def report(from, to)
    @report ||= data({ :api_key     => credentials.api_key,
                       :start       => from.strftime("%Y-%m-%d"),
                       :end         => to.strftime("%Y-%m-%d"),
                       :format      => :json,
                       :columns     => ReportColumns,
                       :report_type => :publisher,
                     }).group_by do |row|
      [row[:package_name], row[:ad_type], Date.parse(row[:day])]
    end
  end

  def data(params)
    cipher_suit_backup = OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers]

    uri = Addressable::URI.parse(BaseUrl)
    uri.query_values = params

    OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers] =
      'HIGH:MEDIUM:!ADH:!EDH:!DHE'

    http = Net::HTTP.new(uri.hostname, 443)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true

    request = Net::HTTP::Get.new uri.request_uri
    response = http.request(request)
    JSON.parse(response.body, :symbolize_names => true)[:results]
  ensure
    OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers] = cipher_suit_backup
  end
end
