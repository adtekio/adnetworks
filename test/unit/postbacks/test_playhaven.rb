require File.dirname(File.expand_path(__FILE__)) + '/../../helper.rb'

module Postbacks
  class TestPlayhaven < Minitest::Test
    def test_klazz
      AdtekioAdnetworks::Postbacks::Playhaven
    end

    context "helper method - compute_params" do
      should "work with empty input" do
        obj = instance_with_event
        mock(SecureRandom).hex.times(2) { "19fd147d6738e02337c4eccd5b3b3813" }

        assert_equal({ :token=>nil, :tracking=>"0",
                       :nonce=>"19fd147d6738e02337c4eccd5b3b3813",
                       :ph_conversion=>1, :sig4=>"ByQeeSt3oxJFbURKiwf5rtwSFkE"},
                     obj.compute_params)

        assert_equal("https://partner-api-ssl.playhaven.com/v4/advertiser/"+
                     "open?nonce=19fd147d6738e02337c4eccd5b3b3813&"+
                     "ph_conversion=1&sig4=ByQeeSt3oxJFbURKiwf5rtwSFkE&"+
                     "token&tracking=0",obj.mac(:ios).first[:url])
      end

      should "work with an event containing an adid" do
        obj = instance_with_event(os(:adid => "adid"))
        mock(SecureRandom).hex.times(2) { "19fd147d6738e02337c4eccd5b3b3813" }

        assert_equal({ :token=>nil, :tracking=>"1",
                       :nonce=>"19fd147d6738e02337c4eccd5b3b3813",
                       :ph_conversion=>1, :sig4=>"B13Vmprec-tMXR7Dep15RLVESE0",
                       :ifa => "adid"},
                     obj.compute_params)

        assert_equal("https://partner-api-ssl.playhaven.com/v4/advertiser/"+
                     "open?ifa=adid&nonce=19fd147d6738e02337c4eccd5b3b3813&"+
                     "ph_conversion=1&sig4=B13Vmprec-tMXR7Dep15RLVESE0&token"+
                     "&tracking=1",obj.mac(:ios).first[:url])
      end

      should "work with an event containing an adid and token" do
        obj = instance_with_event(os(:adid => "adid"),
                                  :netcfg => os(:token => "token"))
        mock(SecureRandom).hex.times(2) { "19fd147d6738e02337c4eccd5b3b3813" }

        assert_equal({ :token=>"token", :tracking=>"1",
                       :nonce=>"19fd147d6738e02337c4eccd5b3b3813",
                       :ph_conversion=>1, :sig4=>"K8f2gGgiD2mgalhnRDmk8MEwUss",
                       :ifa => "adid"},
                     obj.compute_params)

        assert_equal("https://partner-api-ssl.playhaven.com/v4/advertiser/"+
                     "open?ifa=adid&nonce=19fd147d6738e02337c4eccd5b3b3813&"+
                     "ph_conversion=1&sig4=K8f2gGgiD2mgalhnRDmk8MEwUss&"+
                     "token=token&tracking=1",obj.mac(:ios).first[:url])
      end

      should "work with an event containing an adid, token and hmac" do
        nc = os(:token => "token", :hmac => "hmac")
        obj = instance_with_event(os(:adid => "adid"), :netcfg => nc)
        mock(SecureRandom).hex.times(2) { "19fd147d6738e02337c4eccd5b3b3813" }

        assert_equal({ :token=>"token", :tracking=>"1",
                       :nonce=>"19fd147d6738e02337c4eccd5b3b3813",
                       :ph_conversion=>1, :sig4=>"LuCilzd1kDmdhx4MktsHjNWyUCU",
                       :ifa => "adid"},
                     obj.compute_params)

        assert_equal("https://partner-api-ssl.playhaven.com/v4/advertiser/"+
                     "open?ifa=adid&nonce=19fd147d6738e02337c4eccd5b3b3813&"+
                     "ph_conversion=1&sig4=LuCilzd1kDmdhx4MktsHjNWyUCU&"+
                     "token=token&tracking=1",obj.mac(:ios).first[:url])
      end
    end
  end
end
