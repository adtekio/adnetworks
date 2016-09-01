class AdtekioAdnetworks::Cost::Gamegenetics
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:username, :password]
  end

  def csv_data(from, till)
    agent = Mechanize.new
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    agent.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) '+
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.117 '+
      'Safari/537.36'

    agent.post( "https://partner.popmog.com/en/user_session", {
                  :"user_session[email]"        => credentials.username,
                  :"user_session[password]"     => credentials.password,
                  :"user_session[remember_me]"  => 1
                })

    csv_data = agent.post( "https://partner.popmog.com/en/payment_report/advertiser_new", {
                             :"payment_report_filter[begin_date]" => from,
                             :"payment_report_filter[end_date]"   => till,
                             :"payment_report_filter[daily]"      => 1,
                             :csv                                 => 1
                           }).body

    CSV.new(csv_data, :headers => :first_line, :col_sep => ",", :quote_char => '"')
  end

  def campaign_costs(from, till)
    csv_data(from, till).map do |row|
      spends = (row['Cost (currency)'] || "").gsub(' USD','').to_f
      {
        :date        => Date.parse(row['Date'][0..9]),
        :campaign    => row["Country"],
        :adgroup     => row["Campaign Id"],
        :clicks      => row['Clicks'].to_i,
        :conversions => row['CPP Conversion'].to_i,
        :amount      => spends
      }
    end
  end
end
