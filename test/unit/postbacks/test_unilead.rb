require File.dirname(File.expand_path(__FILE__)) + '/../../helper.rb'
require 'ostruct'

module Postbacks
  class TestUnilead < Minitest::Test
    TestKlz = AdtekioAdnetworks::Postbacks::Unilead

    def instance_with_event(event = nil, opts = {})
      TestKlz.new(event || OpenStruct.new,
                  opts[:user] || OpenStruct.new,
                  opts[:netcfg] || OpenStruct.new,
                  opts[:params] || OpenStruct.new)
    end

    context "different urls depending on devices - testing 'check'" do
      should "have different urls for conversion events" do
        assert_equal 2, TestKlz.mac(:ios).size

        params = OpenStruct.new(:device => "ipad")
        obj = instance_with_event(nil, :params => params)
        assert_equal 1, obj.mac(:ios).size
        assert_match /SP1AB/, obj.mac(:ios).first[:url]

        params = OpenStruct.new(:device => "iphone")
        obj = instance_with_event(nil, :params => params)
        assert_equal 1, obj.mac(:ios).size
        assert_match /SP2M0/, obj.mac(:ios).first[:url]
      end

      should "have different urls for funnel events" do
        assert_equal 2, TestKlz.fun(:ios).size

        params = OpenStruct.new(:device => "ipad")
        obj = instance_with_event(nil, :params => params)
        assert_equal 0, obj.fun(:ios).size

        params = OpenStruct.new(:device => "iphone")
        obj = instance_with_event(nil, :params => params)
        assert_equal 0, obj.fun(:ios).size

        params = OpenStruct.new(:device      => "ipad",
                                :funnel_step => "tutorial_complete")
        user   = OpenStruct.new(:click_data => {'click' => "trans_id"})
        obj    = instance_with_event(nil, :params => params, :user => user)

        assert_equal 1, obj.fun(:ios).size
        assert_match /GP2b9.*trans_id/, obj.fun(:ios).first[:url]

        params = OpenStruct.new({:device       => "iphone",
                                  :funnel_step => "tutorial_complete"})
        obj = instance_with_event(nil, :params => params, :user => user)
        assert_equal 1, obj.fun(:ios).size
        assert_match /GP2bF.*trans_id/, obj.fun(:ios).first[:url]
      end

      should "have different urls for payment events" do
        assert_equal 2, TestKlz.pay(:ios).size

        params = OpenStruct.new(:device => "ipad")
        user   = OpenStruct.new(:click_data => {'click' => "trans_id"})
        event  = OpenStruct.new(:revenue => "revenue")
        obj    = instance_with_event(event, :params => params, :user => user)

        assert_equal 1, obj.pay(:ios).size
        assert_match /GP2bL.*revenue.*trans_id.*/, obj.pay(:ios).first[:url]

        params = OpenStruct.new(:device => "iphone")
        obj = instance_with_event(event, :params => params, :user => user)

        assert_equal 1, obj.pay(:ios).size
        assert_match /GP2bR.*revenue.*trans_id.*/, obj.pay(:ios).first[:url]
      end
    end
  end
end
