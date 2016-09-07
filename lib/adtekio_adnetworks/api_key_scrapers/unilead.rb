module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_unilead
      return_token_hash do
        enter_login_details(_g("http://my.unileadnetwork.com/").forms.first).
          submit

        get_and_match("http://my.unileadnetwork.com/stats/stats_api",
                      /Your API Key .+ <i>([^ ]+)[<]/)
      end
    end
  end
end
