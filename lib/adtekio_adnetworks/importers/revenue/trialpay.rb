class AdtekioAdnetworks::Revenue::Trialpay
  include AdtekioAdnetworks::RevenueImport

  def revenues(from, to)
  end

  def report(from,to)
  end

  def dailysummary
    require 'mechanize'
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'

    agent.post("https://merchant.trialpay.com/login/", {
                 :action   => "del",
                 :email    => credentials.username,
                 :password => credentials.password})

    uri = Addressable::URI.new
    uri.query_values = {
      :app_id                    => "",
      :context                   => "",
      :group_by                  => "group_by_app_id_context_and_date",
      :date_group                => "day",
      :date_type                 => 1,
      :date_interval             => 6, # 30 days back
      :csv                       => "Export to CSV",
      "[sort_by]"                => "date",
      "[sort_order]"             => "asc",
      "report_table[sort_by]"    => "date",
      "report_table[sort_order]" => "asc",
    }
    url = "https://merchant.trialpay.com/reports/dailysummary/"
    agent.get("%s?%s" % [url, uri.query]).body
  end
end
