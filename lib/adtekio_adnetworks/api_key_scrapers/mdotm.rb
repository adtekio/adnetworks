module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_mdotm
      return_result_hash do |result|
        agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        form = _g("https://platform.mdotm.com/app/login").forms.first
        page = enter_login_details(form).submit
        page = page.link_with(:text => "Your Profile").click

        page.content =~ /AccountID.*<code>(.+)<\/code>/
        result["account_id"] = $1
        page.content =~ /Your API Key.*<code>(.+)<\/code>/
        result["token"]      = $1
        page.content =~ /Your Secret Key.*<code>(.+)<\/code>/
        result["secret_key"] = $1
      end
    end
  end
end
