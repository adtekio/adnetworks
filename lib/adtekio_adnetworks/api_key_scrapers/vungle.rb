module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_vungle
      return_token_hash do
        csrf_token = get_and_match("https://v.vungle.com/dashboard/login",
                                   /id="csrf" value="([^"]+)"/)

        _p("https://v.vungle.com/dashboard/login", {
             "_csrf"    => csrf_token,
             "email"    => params["username"],
             "password" => params["password"]})

        account_id = get_and_match("https://v.vungle.com/dashboard/reports",
                                   /"account":."_id":"([^"]+)"/)

        page = _g("https://v.vungle.com/dashboard/api/1/"+
                  "accounts/#{account_id}/users")

        JSON.parse(page.content).map {|a|a["secretKey"]}.compact.first
      end
    end
  end
end
