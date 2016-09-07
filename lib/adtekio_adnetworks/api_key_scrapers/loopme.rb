module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_loopme
      return_token_hash do
        form = _g("https://loopme.me/login").forms.first
        enter_login_details(form).submit
        page = _g("https://loopme.me/account/settings")
        page.search("span[id=api_auth_token]").first.children.first.text
      end
    end
  end
end
