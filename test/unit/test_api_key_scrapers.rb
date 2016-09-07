require File.dirname(File.expand_path(__FILE__)) + '/../helper.rb'

class TestApiKeyScrapers < Minitest::Test
  context "specific scrapers" do
    setup do
      @scraper = AdtekioAdnetworks::ApiKeyScrapers.new
    end

    should "have working unilead" do
      mock(@scraper)._g("http://my.unileadnetwork.com/") do
        OpenStruct.new(:forms => ["fubar"])
      end
      mock(@scraper).enter_login_details('fubar') do
        OpenStruct.new(:submit => "donothing")
      end

      mock(@scraper).
        get_and_match("http://my.unileadnetwork.com/stats/stats_api",
                      /Your API Key .+ <i>([^ ]+)[<]/) { "token" }

      assert_equal({ :token => "token"}, @scraper.obtain_key_for("unilead",{}))
    end

    should "have working vungle" do
      params = { "username" => "username", "password" => "password"}

      mock_agent = Object.new.tap do |o|
        mock(o).post("https://v.vungle.com/dashboard/login", {
                       "_csrf"    => "csrf_token",
                       "email"    => params["username"],
                       "password" => params["password"]})
      end

      @scraper.instance_variable_set("@agent", mock_agent)

      mock(@scraper).get_and_match("https://v.vungle.com/dashboard/login",
                                   /id="csrf" value="([^"]+)"/) {"csrf_token"}
      mock(@scraper).get_and_match("https://v.vungle.com/dashboard/reports",
                                   /"account":."_id":"([^"]+)"/) {"account_id"}

      mock(@scraper)._g("https://v.vungle.com/dashboard/api/1/"+
                        "accounts/account_id/users") do
        OpenStruct.new(:content => [{ "secretKey" => "secret_key"}].to_json)
      end

      assert_equal({:token=>"secret_key"},
                   @scraper.obtain_key_for("vungle",params))
    end
  end
end
