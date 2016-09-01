class AdtekioAdnetworks::Cost::Mmg
  include AdtekioAdnetworks::CostImport

  define_required_credentials do
    [:username, :password]
  end

  def csv_data(date)
    agent = Mechanize.new
    agent.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) '+
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.117 '+
      'Safari/537.36'

    agent.post( "http://reporting.mobilda.com/adcenter/login.php", {
                  :username     => credentials.username,
                  :password     => credentials.password,
                  :client_time  => (DateTime.now.strftime("%s").to_i +
                                    3600).to_s + ".132",
                  :screen_width => 1920 })

    datestr = date.strftime("%Y-%m-%d")
    bodystr = agent.post( "http://reporting.mobilda.com/adcenter/"+
                          "index.php?mod=reports&act=view", {
                            "breadcrumb_title"  => nil,
                            "group_by"          => "product_id",
                            "pass_breadcrumbs"  => 0,
                            "route_id"          => 0,
                            "filter_country"    => nil,
                            "filter_product_id" => nil,
                            "dt_range"          => "#{datestr}:#{datestr}",
                            "dt_from"           => datestr,
                            "dt_to"             => datestr,
                            "pagenum"           => 1,
                            "perpage"           => 1000,
                            "export_to_excel"   => 1
                          }).body

    # mmg use a pop-up via Javascript, i.e. you press download as
    # excel and the page gets submitted, on the new page a Javascript
    # popup opens that starts the download. So we need to scan the
    # page for the download hash and then use that.
    hex = bodystr.match(/downloadCSVLite\('reports','(.*)'\);/)

    agent.get("http://reporting.mobilda.com/adcenter/index.php?"+
              "mod=reports&act=download_csv&hash=#{hex[1]}&output=file") if hex
  end

  def campaign_costs(from, till)
    from.upto(till).map do |date|
      resp = csv_data(date)
      next unless resp
      CSV.new(resp.body, :headers => :first_line, :col_sep => ",",
              :quote_char => '"').map do |row|
        campaign_name = row["Campaign"].split('::').last.strip.gsub(' ', '_')
        next if campaign_name == "Total"
        next if row['Spent($)'].to_f == 0.0
        {
          :date        => date,
          :campaign    => campaign_name,
          :clicks      => row['Clicks'].to_i,
          :conversions => row['Conversions'].to_i,
          :amount      => row['Spent($)'].to_f
        }
      end
    end.flatten
  end
end
