module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_crossinstall
      return_token_hash do
        agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        form = _g("https://secure.crossinstall.com/login").forms.first
        enter_login_details(form).submit.link_with(:text => " API Key").
          click.search("input[name=api_key]").first.attributes["value"].value
      end
    end
  end
end
