class AdtekioAdnetworks::Cost::Nanigans
  include AdtekioAdnetworks::CostImport

  APPLE_SHARE = {
    :AUD	=> 0.636,
    :CHF	=> 0.648,
    :DKK	=> 0.608,
    :EUR	=> 0.608,
    :GBP	=> 0.608,
    :NOK	=> 0.560,
    :SEK	=> 0.608,
  }


  REVENUE_UPDATE_DATE = Date.parse('2014-05-26')

  def booking_days(date)
    max_days = (Date.today - date).to_i
    [1, 2, 3, 7, 14, 30, 60, 90, 120].select do |day|
      day <= max_days
    end
  end

  def day_to_nanigans_field(day)
    case day.to_i
    when 1 then :a8val
    when 2 then :a9val
    when 3 then :a10val
    when 7 then :a5val
    when 14 then :a11val
    when 30 then :a12val
    when 60 then :a13val
    when 90 then :a14val
    when 120 then :a15val
    else
      raise "invalid day"
    end
  end

  def campaign_data(from, till, game_type)
    time_gmt = Time.now().getgm.strftime("%Y%m%d%H%M%S")
    sig_string = "#{credentials.partner_id}&#{time_gmt}&#{credentials.secret}"
    sig = Digest::SHA1.base64digest(sig_string)
    sig = sig.gsub('+','.').gsub('/', '_')

    uri = Addressable::URI.parse("https://wwwapi.nanigans.com/reporting/api/wooga/generateAdLevelReport")
    http = Net::HTTP.new(uri.hostname, 443)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    http.ssl_timeout = 900
    http.read_timeout = 900

    from.upto(till).map do |date|
      booking_fields = booking_days(date).map {|day| day_to_nanigans_field(day)}
      fields = [:site, :budget_pool, :ad_plan, :countries, :user_device]
      fields = fields.push(:placement_id) if game_type == :flash
      data = {
        :method => :generateAdLevelReport,
        :params => {
          :partner_id   => credentials.partner_id,
          :tms          => time_gmt,
          :sig          => sig,
          :date         => date.to_s,
          :attribution  => :click,
          :fields       => fields,
          :metrics      => [:impressions, :clicks, :a1, :fb_spend_wfees, :purchase_value, :purchase_users, :a5val] + booking_fields
        }
      }

      request = Net::HTTP::Post.new(uri.request_uri,
                                    {"Content-Type" => "application/json"})
      request.basic_auth credentials.username, credentials.password
      request.body = data.to_json

      res = http.request(request)
      JSON.parse(res.body, :symbolize_names => true)[:_data][:data]
    end.flatten
  end

  def campaign_costs(from, till)
    [:mobile, :flash].map do |game_type|
      campaign_data(from, till, game_type).map do |campaign|
        next if campaign[:budget_pool] =~ /rtb/i
        next if campaign[:fb_spend_wfees].to_f == 0.0

        date = Date.parse(campaign[:date])
        [:impressions, :clicks, :a1, :purchase_users, :purchase_value].each do |key|
          campaign[key] = nil if campaign[key].to_f == 0.0
        end

        campaign_name = game_type == :flash ? campaign[:placement_id] : campaign[:ad_plan]
        country = campaign[:countries].try(:downcase).try(:split, /_|,/).try(:last)
        device = campaign[:user_device].try(:downcase).try(:split, /_|,/).try(:last)

        {
          :date           => date,
          :campaign       => campaign_name,
          :adgroup        => country,
          :ad             => device,
          :impressions    => campaign[:impressions].try(:to_i),
          :clicks         => campaign[:clicks].try(:to_i),
          :conversions    => campaign[:a1].try(:to_i),
          :amount         => campaign[:fb_spend_wfees].try(:to_f),
          :target_country => country,
          :target_device  => device,
        }
      end.compact
    end.flatten
  end
end
