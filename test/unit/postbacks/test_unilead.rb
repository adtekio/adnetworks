require File.dirname(File.expand_path(__FILE__)) + '/../../helper.rb'

module Postbacks
  class TestUnilead < Minitest::Test
    def test_klazz
      AdtekioAdnetworks::Postbacks::Unilead
    end

    context "different urls depending on devices - testing 'check'" do
      should "have different urls for conversion events" do
        assert_equal 2, test_klazz.mac(:ios).size

        params = os(:device => "ipad")
        obj = instance_with_event(nil, :params => params)
        assert_equal 1, obj.mac(:ios).size
        assert_match /SP1AB/, obj.mac(:ios).first[:url]

        params = os(:device => "iphone")
        obj = instance_with_event(nil, :params => params)
        assert_equal 1, obj.mac(:ios).size
        assert_match /SP2M0/, obj.mac(:ios).first[:url]
      end

      should "have different urls for funnel events" do
        assert_equal 2, test_klazz.fun(:ios).size

        params = os(:device => "ipad")
        obj = instance_with_event(nil, :params => params)
        assert_equal 0, obj.fun(:ios).size

        params = os(:device => "iphone")
        obj = instance_with_event(nil, :params => params)
        assert_equal 0, obj.fun(:ios).size

        params = os(:device => "ipad", :funnel_step => "tutorial_complete")
        user   = os(:click_data => {'click' => "trans_id"})
        obj    = instance_with_event(nil, :params => params, :user => user)

        assert_equal 1, obj.fun(:ios).size
        assert_match /GP2b9.*trans_id/, obj.fun(:ios).first[:url]

        params = os({:device => "iphone", :funnel_step => "tutorial_complete"})
        obj = instance_with_event(nil, :params => params, :user => user)
        assert_equal 1, obj.fun(:ios).size
        assert_match /GP2bF.*trans_id/, obj.fun(:ios).first[:url]
      end

      should "have different urls for payment events" do
        assert_equal 2, test_klazz.pay(:ios).size

        params = os(:device => "ipad")
        user   = os(:click_data => {'click' => "trans_id"})
        event  = os(:revenue => "revenue")
        obj    = instance_with_event(event, :params => params, :user => user)

        assert_equal 1, obj.pay(:ios).size
        assert_match /GP2bL.*revenue.*trans_id.*/, obj.pay(:ios).first[:url]

        params = os(:device => "iphone")
        obj = instance_with_event(event, :params => params, :user => user)

        assert_equal 1, obj.pay(:ios).size
        assert_match /GP2bR.*revenue.*trans_id.*/, obj.pay(:ios).first[:url]
      end
    end
  end
end
