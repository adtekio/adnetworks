module AdtekioAdnetworks
  class ApiKeyScrapers
    def key_for_adcolony
      return_token_hash do
        csrf_token =
          get_and_match("https://clients.adcolony.com/login",
                        /_csrf.:.([^"]+)"/)

        data = {
          "_csrf"    => csrf_token,
          "email"    => params["username"],
          "password" => params["password"]
        }

        post_and_match("https://clients.adcolony.com/login", data,
                       /single_access_token.:.([^"]+)"/)
      end
    end
  end
end
