require File.dirname(File.expand_path(__FILE__)) + '/../helper.rb'
require 'ostruct'

class TestPostbacks < Minitest::Test
  context "generate urls" do
    should "be able to generate urls using empty data" do
      event_obj = OpenStruct.new(:params => OpenStruct.new,
                                 :time => Time.now)
      user      = OpenStruct.new(:click_data => OpenStruct.new)
      netcfg    = OpenStruct.new

      for_all_events do |network, klz, platform, event|
        klz.new(event_obj,user,netcfg).send(event, platform).each do |urlcfg|
          assert_equal([:url, :body, :header], urlcfg.keys,
                       "Failed for #{network}/ #{platform} / #{event}")
        end
      end
    end

    should "be able to generate url templates" do
      for_all_events do |network, klz, platform, event|
        klz.send(event, platform).each do |desc|
          assert_kind_of(String, desc[:url],
                         "Failed for #{network}/ #{platform} / #{event}")
          assert(desc[:user_required].is_a?(TrueClass) ||
                 desc[:user_required].is_a?(FalseClass),
                 "Failed for #{network}/ #{platform} / #{event}")
          assert(desc[:store_user].is_a?(TrueClass) ||
                 desc[:store_user].is_a?(FalseClass),
                 "Failed for #{network}/ #{platform} / #{event}")
        end
      end
    end
  end
end
