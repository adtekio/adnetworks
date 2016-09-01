class AdtekioAdnetworks::Cost::Tokenads
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:username, :password]
  end

  def campaign_costs(from, till)
    require 'csv'
    require 'mechanize'

    agent = Mechanize.new
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    agent.read_timeout = 120
    agent.user_agent_alias = 'Mac Safari'

    agent.post("https://manage.tokenads.com/AdvLogin", {
                 :submit           => "Submit",
                 :adv_ContactEmail => credentials.username,
                 :adv_AccountPwd   => credentials.password
               })

    csv = agent.post("https://manage.tokenads.com/AdvGrid/Report", {
                       "stt_Date_start" => from.strftime("%Y-%m-%d"),
                       "stt_Date_end"   => till.strftime("%Y-%m-%d"),
                       "stt_CampaignId" => "",
                       "group_1"        => "stt_Date",
                       "group_2"        => "stt_CampaignId",
                       "sortby_1"       => "stt_Date",
                       "c_rpp"          => "5000",
                       "export"         => "Export",
                       "searched"       => "1"
                     }).body

    CSV.new(csv, :headers => :first_line, :col_sep => ",", :quote_char => '"').
      to_a.map do |row|
      {
        :date        => Date.parse(row['Date'], "%Y-%m-%d"),
        :campaign    => row['Campaign'],
        :clicks      => row['Clicks'].to_i,
        :conversions => row['Actions'].to_i,
        :amount      => row['Advertiser Cost (USD)'].gsub(/,/, '').gsub(/[$]/, '').to_f
      }
    end
  end
end
