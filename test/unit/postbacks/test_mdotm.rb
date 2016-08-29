require File.dirname(File.expand_path(__FILE__)) + '/../../helper.rb'

module Postbacks
  class TestMdotm < Minitest::Test
    def test_klazz
      AdtekioAdnetworks::Postbacks::Mdotm
    end

    context "helper method - android_id" do
      should "work with empty input" do
        obj = instance_with_event
        assert_equal nil, obj.android_id
      end

      should "work with some input" do
        params = os(:android_id => "android_id")
        obj = instance_with_event(nil, :params => params)
        assert_equal "696565da69675bb7efe52dc8d7c2e7cd43b111f7", obj.android_id
      end

      should "generate url" do
        params = os(:android_id => "android_id")
        nc     = os(:adv_id => "advertiser_id")
        event  = os(:bundleid => "bundleid")
        obj    = instance_with_event(event, :params => params, :netcfg => nc)

        r = obj.mac(:android)
        assert_equal("http://ads.mdotm.com/ads/receiver.php?advid="+
                     "advertiser_id&androidid=696565da69675bb7efe52"+
                     "dc8d7c2e7cd43b111f7&clickid=&deviceid=&"+
                     "package=bundleid", r.first[:url])
      end
    end
  end
end
