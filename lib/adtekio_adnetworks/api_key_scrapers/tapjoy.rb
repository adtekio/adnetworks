module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_tapjoy
      return_token_hash do
        page = agent.post("https://dashboard.tapjoy.com/api/client/v1/session",{
                            'username' => params["username"],
                            'password' => params["password"],
                            "_method"  => "put"})

        user_id = get_and_match(JSON.parse(page.content)["link"] + "/d",
                                /User Id., "([^"]+)"/)

        page = _g("https://dashboard.tapjoy.com/api/client/users/#{user_id}")
        JSON.parse(page.content)["result"]["user"]["api_key"]
      end
    end
  end
end
