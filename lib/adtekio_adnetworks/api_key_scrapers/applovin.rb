module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_applovin
      return_token_hash do
        enter_login_details(_g("https://www.applovin.com/login").forms.first).
          submit

        page = _g("https://www.applovin.com/account")
        page.search("input[id=report_key]").first.attributes["value"].value
      end
    end
  end
end
