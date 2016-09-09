require File.dirname(File.expand_path(__FILE__)) + '/../helper.rb'

class TestApiKeyScrapers < Minitest::Test
  def define_mock_agent(&block)
    mock = Object.new.tap { |o| yield(o) }
    @scraper.instance_variable_set("@agent", mock)
  end

  context "base api scraper class" do
    setup do
      @scraper = AdtekioAdnetworks::ApiKeyScrapers.new
    end

    should "send the right method" do
      mock(@scraper).key_for_banana { "apple" }
      assert_equal "apple", @scraper.obtain_key_for("banana", {})
    end

    should "have working get_and_match that returns match contents" do
      mock(@scraper)._g("url") { os(:content => "match this") }

      assert_equal "this", @scraper.send(:get_and_match, "url", /match (.+)/)
    end

    should "return nil if no match when using get_and_match" do
      mock(@scraper)._g("url") { os(:content => "dontmatch! this") }

      assert_nil @scraper.send(:get_and_match, "url", /match (.+)/)
    end

    should "have a working post_and_match" do
      mock(@scraper)._p("url",{}) { os(:content => "match this") }

      assert_equal("this",
                   @scraper.send(:post_and_match, "url", {}, /match (.+)/))
    end

    should "not match and return nil when using post_and_match" do
      mock(@scraper)._p("url",{}) { os(:content => "dontmatch! this") }

      assert_nil @scraper.send(:post_and_match, "url", {}, /match (.+)/)
    end

    should "have working enter_login_details" do
      { "work" =>
        [ os({ :name => "email",    :value => nil}),
          os({ :name => "password", :value => nil})],
        "case insensitive" =>
        [ os({ :name => "EmAiL",    :value => nil}),
          os({ :name => "PassWord", :value => nil})],
        "password can be written passwd" =>
        [ os({ :name => "EmAiL",    :value => nil}),
          os({ :name => "PassWd",   :value => nil})]
      }.each do |test_name, fields|
        msg  = "Failed for #{test_name}"
        form = os(:fields => fields)

        params = { "username" => "username", "password" => "password"}
        @scraper.instance_variable_set("@params", params)

        assert_equal form, @scraper.send(:enter_login_details, form), msg
        assert_equal "username", fields.first.value, msg
        assert_equal "password", fields.last.value, msg
      end
    end
  end

  context "specific scrapers" do
    setup do
      @scraper = AdtekioAdnetworks::ApiKeyScrapers.new
    end

    should "have working adcolony" do
      params = { "username" => "username", "password" => "password"}
      mock(@scraper).get_and_match("https://clients.adcolony.com/login",
                                   /_csrf.:.([^"]+)"/) { "csrf_token" }
      data = {
        "_csrf"    => "csrf_token",
        "email"    => params["username"],
        "password" => params["password"]
      }

      mock(@scraper).post_and_match("https://clients.adcolony.com/login",data,
                                    /single_access_token.:.([^"]+)"/) {"token"}

      assert_equal({:token => "token"},
                   @scraper.obtain_key_for("adcolony",params))
    end

    should "have working applift" do
      forms = os( :forms => ["empty_form"])
      mock(@scraper)._g("https://partner.applift.com") { forms }

      login_page = os(:submit => "")
      mock(@scraper).enter_login_details("empty_form") { login_page }

      mock(@scraper).
        get_and_match("https://partner.applift.com/stats/stats_api",
                      /Your API Key .+ <i>([^ ]+)[<]/) { "token" }

      assert_equal({:token => "token"},
                   @scraper.obtain_key_for("applift",{}))
    end

    should "have working applovin" do
      forms = os( :forms => ["empty_form"])
      mock(@scraper)._g("https://www.applovin.com/login") { forms }

      login_page = os(:submit => "")
      mock(@scraper).enter_login_details("empty_form") { login_page }

      page = Object.new.tap do |o|
        mock(o).search("input[id=report_key]") do
          [os(:attributes => {"value" => os(:value => "token")})]
        end
      end
      mock(@scraper)._g("https://www.applovin.com/account") { page }

      assert_equal({:token => "token"},
                   @scraper.obtain_key_for("applovin",{}))
    end

    should "have working chartboost" do
      params = { "username" => "username", "password" => "password"}

      define_mock_agent do |o|
        mock(o).post("https://dashapi.chartboost.com/v3/login", {
                       "email"    => params["username"],
                       "password" => params["password"]})
      end
      page = os(:content => { "response" => { "user_id" => "user_id",
                    "user_signature" => "user_signature"}}.to_json)
      mock(@scraper)._g("https://dashapi.chartboost.com/v3/"+
                        "companies?with=money%2users,ounts") { page }

      assert_equal({"user_id"=>"user_id", "signature"=>"user_signature"},
                   @scraper.obtain_key_for("chartboost",params))
    end

    should "have working crossinstall" do
      forms = os( :forms => ["empty_form"])
      mock(@scraper)._g("https://secure.crossinstall.com/login") { forms }

      mock_search = Object.new.tap do |o|
        mock(o).search("input[name=api_key]") do
          [os(:attributes => {"value" => os(:value => "token")})]
        end
      end
      mock_content = Object.new.tap do |o|
        mock(o).link_with(:text => " API Key") { os(:click => mock_search) }
      end
      details_page = os(:submit => mock_content)
      mock(@scraper).enter_login_details("empty_form") { details_page }

      assert_equal({:token => "token"},
                   @scraper.obtain_key_for("crossinstall",{}))
    end

    should "have working leadbolt" do
      forms = os( :forms => ["empty_form"])
      mock(@scraper)._g("https://www.leadboltnetwork.net/advertiser/login") do
        forms
      end
      login_page = os(:submit => "")
      mock(@scraper).enter_login_details("empty_form") { login_page }

      page = Object.new.tap do |o|
        mock(o).search("div p[class=form-control-static]").times(2) do
          [os(:text => "advertiser_id"), os(:text => "secret_key")]
        end
      end
      mock(@scraper)._g("https://www.leadboltnetwork.net/a/"+
                        "account/accountsettings") { page }

      assert_equal({"secret_key"=>"secret_key",
                     "advertiser_id"=>"advertiser_id"},
                   @scraper.obtain_key_for("leadbolt",{}))
    end

    should "have working loopme" do
      forms = os( :forms => ["empty_form"])
      mock(@scraper)._g("https://loopme.me/login") { forms }
      login_page = os(:submit => "")
      mock(@scraper).enter_login_details("empty_form") { login_page }

      search_results = [os(:children => [os(:text => "token")])]
      settings_page = Object.new.tap do |o|
        mock(o).search("span[id=api_auth_token]") { search_results }
      end
      mock(@scraper)._g("https://loopme.me/account/settings") { settings_page }

      assert_equal({:token => "token"}, @scraper.obtain_key_for("loopme",{}))
    end

    should "have working mdotm" do
      forms = os( :forms => ["empty_form"])
      mock(@scraper)._g("https://platform.mdotm.com/app/login") { forms }

      content = <<-EOF
        AccountID.*<code>AccountId<\/code>
        Your API Key.*<code>APIKEY<\/code>
        Your Secret Key.*<code>SECRETKEY<\/code>
      EOF

      profile_page = os(:click => os({:content => content}))
      mock_page = Object.new.tap do |o|
        mock(o).link_with(:text => "Your Profile") { profile_page }
      end

      page = os(:submit => mock_page)
      mock(@scraper).enter_login_details("empty_form") { page }

      assert_equal({"account_id"=>"AccountId", "token"=>"APIKEY",
                     "secret_key"=>"SECRETKEY"},
                   @scraper.obtain_key_for("mdotm",{}))
    end

    should "have working revmob" do
      params = { "username" => "username", "password" => "password"}
      page   = os(:content => {
                    "user_id" => "user_id",
                    "auth_token" => "auth_token"}.to_json)

      define_mock_agent do |o|
        mock(o).post("https://www.revmobmobileadnetwork.com/home/signIn", {
                       "emailSignIn" => params["username"],
                       "pass"        => params["password"],
                       "originalUrl" => "/users/session/new"})

        mock(o).post("https://www.revmobmobileadnetwork.com/myMedias", {
                       "countEnable" => "false",
                       "filterText"  => "",
                       "limitEnd"    => 15,
                       "limitStart"  => 15}) { page }
      end

      assert_equal({ "user_id" => "user_id", "auth_token" => "auth_token"},
                   @scraper.obtain_key_for("revmob",params))
    end

    should "have working tapjoy" do
      params = { "username" => "username", "password" => "password"}
      page   = os(:content => {"link" => "link"}.to_json)

      define_mock_agent do |o|
        mock(o).post("https://dashboard.tapjoy.com/api/client/v1/session", {
                       "_method"  => "put",
                       "username" => params["username"],
                       "password" => params["password"]}) { page }
      end

      mock(@scraper).get_and_match("link/d",/User Id., "([^"]+)"/) {"user_id"}
      mock(@scraper).
        _g("https://dashboard.tapjoy.com/api/client/users/user_id") do
        os(:content => {"result" => {"user" =>
               {"api_key" => "api_key"}}}.to_json)
      end

      assert_equal({ :token => "api_key"},
                   @scraper.obtain_key_for("tapjoy",params))
    end

    should "have working unilead" do
      mock(@scraper)._g("http://my.unileadnetwork.com/") do
        os(:forms => ["fubar"])
      end
      mock(@scraper).enter_login_details('fubar') do
        os(:submit => "donothing")
      end

      mock(@scraper).
        get_and_match("http://my.unileadnetwork.com/stats/stats_api",
                      /Your API Key .+ <i>([^ ]+)[<]/) { "token" }

      assert_equal({ :token => "token"}, @scraper.obtain_key_for("unilead",{}))
    end

    should "have working vungle" do
      params = { "username" => "username", "password" => "password"}

      define_mock_agent do |o|
        mock(o).post("https://v.vungle.com/dashboard/login", {
                       "_csrf"    => "csrf_token",
                       "email"    => params["username"],
                       "password" => params["password"]})
      end

      mock(@scraper).get_and_match("https://v.vungle.com/dashboard/login",
                                   /id="csrf" value="([^"]+)"/) {"csrf_token"}
      mock(@scraper).get_and_match("https://v.vungle.com/dashboard/reports",
                                   /"account":."_id":"([^"]+)"/) {"account_id"}

      mock(@scraper)._g("https://v.vungle.com/dashboard/api/1/"+
                        "accounts/account_id/users") do
        os(:content => [{ "secretKey" => "secret_key"}].to_json)
      end

      assert_equal({:token=>"secret_key"},
                   @scraper.obtain_key_for("vungle",params))
    end
  end
end
