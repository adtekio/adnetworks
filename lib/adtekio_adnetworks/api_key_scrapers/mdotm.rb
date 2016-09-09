module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_mdotm
      return_result_hash do |result|
        agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        form = _g("https://platform.mdotm.com/app/login").forms.first
        page = enter_login_details(form).submit
        page = page.link_with(:text => "Your Profile").click

        {
          "account_id" => /AccountID.*<code>(.+)<\/code>/,
          "token"      => /Your API Key.*<code>(.+)<\/code>/,
          "secret_key" => /Your Secret Key.*<code>(.+)<\/code>/
        }.each do |key, regexp|
          page.content =~ regexp
          result[key] = $1
        end
      end
    end
  end
end
