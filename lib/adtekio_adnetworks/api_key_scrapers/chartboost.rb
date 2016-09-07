module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_chartboost
      return_result_hash do |result|
        agent.post("https://dashapi.chartboost.com/v3/login", {
                     "email"    => params["username"],
                     "password" => params["password"]
                   })

        chsh = JSON.parse(_g("https://dashapi.chartboost.com/v3/"+
                             "companies?with=money%2users,ounts").content)

        result["user_id"]   = chsh["response"]["user_id"]
        result["signature"] = chsh["response"]["user_signature"]
      end
    end
  end
end
