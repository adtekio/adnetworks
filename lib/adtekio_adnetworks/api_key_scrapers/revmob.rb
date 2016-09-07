module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_revmob
      return_result_hash do |result|
        agent.post("https://www.revmobmobileadnetwork.com/home/signIn",{
                     "emailSignIn" => params["username"],
                     "pass"        => params["password"],
                     "originalUrl" => "/users/session/new"})

        page = agent.post("https://www.revmobmobileadnetwork.com/myMedias",{
                            "countEnable" => "false",
                            "filterText"  => "",
                            "limitEnd"    => 15,
                            "limitStart"  => 15})

        hsh = JSON.parse(page.content)
        result["user_id"]    = hsh["user_id"]
        result["auth_token"] = hsh["auth_token"]
      end
    end
  end
end
