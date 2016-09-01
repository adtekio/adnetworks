class AdtekioAdnetworks::Cost::Matomy
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:username, :password]
  end

  def campaign_costs(from, till)
    require 'mechanize'

    agent = Mechanize.new
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    agent.user_agent_alias = 'Mac Safari'

    agent.post("https://network.adsmarket.com/site/LoginAttempt?rlink=", {
                 :login     => "login",
                 :usr_Email => credentials.username,
                 :usr_Pwd   => credentials.password})

    page = agent.
      post("https://network.adsmarket.com/site/MerchantReportsEarnings", {
             "group1"                         => "std_Date",
             "group2"                         => "std_CampaignId",
             "group3"                         => "std_AffiliateId",
             "program_id"                     => 0,
             "campaign_type"                  => 0,
             "campaign_status"                => 0,
             "creative_type"                  => 0,
             "creative_size"                  => 0,
             "product_activity"               => -1,
             "filter_by"                      => 1,
             "timeperiod"                     => 7,
             "timeperiod_span_start"          => from.strftime("%d-%b-%Y"),
             "timeperiod_span_end"            => till.strftime("%d-%b-%Y"),
             "approved_timeperiod"            => 9,
             "approved_timeperiod_span_start" => "",
             "approved_timeperiod_span_end"   => "",
             "export_csv"                     => "export to CSV",
           })

    # retrieve the CSV content. There seems to be a prefix of
    # \xEF\xBB\xBF in the csv data, so we replace this if it's
    # there.
    bodystr = page.links.select do |a|
      a.text == "click here to download file "
    end.first.click.body.sub(/^.?{3}Date/,"Date")

    CSV.new(bodystr, :headers => :first_line, :col_sep => ",",
            :quote_char => '"').to_a.map do |row|
      next if row['Campaign'].blank?

      {
        :network     => network,
        :campaign    => row['Campaign'],
        :adgroup     => :banner,
        :ad          => row["Publisher ID"],
        :impressions => row['Impressions'].to_i,
        :clicks      => row['Clicks'].to_i,
        :conversions => row['Leads'].to_i,
        :amount      => row['Approved Commissions'].gsub(/,/, '').to_f,
        :date        => Date.parse(row['Date']),
      }
    end
  end
end
