module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_applift
      return_token_hash do
        enter_login_details(_g("https://partner.applift.com").forms.first).
          submit

        get_and_match("https://partner.applift.com/stats/stats_api",
                    /Your API Key .+ <i>([^ ]+)[<]/)
      end
    end
  end
end
