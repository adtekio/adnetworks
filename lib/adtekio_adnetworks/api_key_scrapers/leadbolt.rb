module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_leadbolt
      return_result_hash do |r|
        form =
          _g("https://www.leadboltnetwork.net/advertiser/login").forms.first
        enter_login_details(form).submit

        page = _g("https://www.leadboltnetwork.net/a/account/accountsettings")

        r["secret_key"] =
          page.search("div p[class=form-control-static]").last.text
        r["advertiser_id"] =
          page.search("div p[class=form-control-static]")[-2].text
      end
    end
  end
end
