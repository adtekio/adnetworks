class AdtekioAdnetworks::Cost::Googleadwords
  include AdtekioAdnetworks::CostImport

  API_VERSION = :v201509

  define_required_credentials do
    [:client_key, :client_secret, :developer_token, :customer_id,
     :access_token, :refresh_token, :issued_at, :expires_in, :id_token,
     :verification_code]
  end

  def client
    args = {
      :authentication => {
        :method               => 'OAuth2',
        :oauth2_client_id     => credentials.client_key,
        :oauth2_client_secret => credentials.client_secret,
        :developer_token      => credentials.developer_token,
        :oauth2_access_type   => 'offline',
        :client_customer_id   => credentials.customer_id,
        :user_agent           => 'Mopet',
      },
      :service => {
        :environment => 'PRODUCTION'
      }
    }

    if !credentials.access_token.blank? && !credentials.refresh_token.blank?
      args[:authentication] = args[:authentication].
        merge({:oauth2_token => {
                  :access_token   => credentials.access_token,
                  :refresh_token  => credentials.refresh_token,
                  :issued_at      => DateTime.parse(credentials.issued_at),
                  :expires_in     => credentials.expires_in.to_i,
                  :id_token       => credentials.id_token.blank? ? nil : credentials.id_token,
                }})
    end

    @client ||= begin
                  AdwordsApi::Api.new(args)
                rescue Exception => e
                  puts e.message
                  puts e.backtrace
                end
  end

  def load_data(from, till)
    report_util = client.report_utils(API_VERSION)
    report_file_name  = Tempfile.new('adword_report').path
    report_definition = {
      :selector => {
        :fields => ['Date', 'CampaignName', 'CampaignId', 'AdGroupName',
                    'AdGroupId', 'Impressions', 'Clicks', 'ConvertedClicks',
                    'Cost'],
        :date_range => {
          :min => from.strftime('%Y%m%d'),
          :max => till.strftime('%Y%m%d'),
        },
      },
      :report_name              => 'ADGROUP_PERFORMANCE_REPORT',
      :report_type              => 'ADGROUP_PERFORMANCE_REPORT',
      :date_range_type          => 'CUSTOM_DATE',
      :download_format          => 'CSV',
      :include_zero_impressions => false,
    }

    report_util.download_report_as_file(report_definition, report_file_name)
    content = File.foreach(report_file_name).to_a[1..-2].join()
    CSV.parse(content, :headers => true).map do |row|
      row.to_h
    end
  end

  def campaign_costs(from, till)
    load_data(from, till).map do |campaign|
      amount = campaign["Cost"].to_f/1_000_000
      next if amount == 0

      {
        :date         => Date.parse(campaign["Day"]),
        :campaign     => campaign["Campaign ID"].downcase,
        :adgroup      => campaign["Ad group ID"].downcase,
        :impressions  => campaign["Impressions"].to_i,
        :clicks       => campaign["Clicks"].to_i,
        :conversions  => campaign["Converted clicks"].to_i,
        :amount       => amount,
      }
    end
  end

  def oauth2_token
    client.
      authorize(:oauth2_verification_code => credentials.verification_code)
  end

  def generate_link_to_verification_code
    client.authorize() { |auth_url| return auth_url }
  end
end
