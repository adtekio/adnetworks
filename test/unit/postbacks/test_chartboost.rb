require File.dirname(File.expand_path(__FILE__)) + '/../../helper.rb'
require 'ostruct'

module Postbacks
  class TestChartboost < Minitest::Test
    TestKlz = AdtekioAdnetworks::Postbacks::Chartboost

    def instance_with_event(event = nil, opts = {})
      TestKlz.new(event || OpenStruct.new,
                  opts[:user] || OpenStruct.new,
                  opts[:netcfg] || OpenStruct.new,
                  opts[:params] || OpenStruct.new)
    end

    class ChartboostEvent < OpenStruct
      def android?
        !!is_android
      end
    end

    context "helper methods - iap_body" do
      should "work with empty input" do
        e = ChartboostEvent.new(:currency      => "CUR",
                                :trigger_stamp => "STAMP",
                                :adid          => "ADID")
        nc = OpenStruct.new(:api_token =>"TOKEN")
        params = OpenStruct.new(:price => 1.2,
                                :st1   => "PRODUCT_ID")

        obj = instance_with_event(e, :netcfg => nc, :params => params)
        hsh = JSON.parse(obj.iap_body)

        assert_equal("PRODUCT_ID", hsh["iap"]["product_id"])
        assert_equal("ADID",       hsh["identifiers"]["ifa"])
        assert_equal("TOKEN",      hsh["token"])
        assert_equal("CUR",        hsh["iap"]["currency"])
        assert_equal("STAMP",      hsh["timestamp"])
      end
    end

    context "helper methods - signature" do
      should "work with empty input" do
        obj = instance_with_event(ChartboostEvent.new)
        assert_equal("cccc6a43f6a1956435a451d876272ad7"+
                     "aae1ac0baec87f64ab27f8b131ccb2f8", obj.signature)
      end

      should "work with all inputs" do
        e   = OpenStruct.new(:trigger_stamp => "fubar")
        nc  = OpenStruct.new(:app_id => "app_id", :api_token => "api_token")
        obj = instance_with_event(e, :netcfg => nc)
        assert_equal("85191be548c623170605aaf539a03fa3"+
                     "9810f2c66e6262da3529ddefc79a8fb8", obj.signature)
      end
    end

    context "helper methods - install_signature" do
      should "work with empty input" do
        obj = instance_with_event(ChartboostEvent.new)
        assert_equal("b6577f8ada64c295ee9a927071274004"+
                     "d0cc592428a6c80175997a518086bf66", obj.install_signature)
      end

      should "work with all inputs" do
        e   = OpenStruct.new(:trigger_stamp => "fubar")
        nc  = OpenStruct.new(:app_id => "app_id", :api_token => "api_token",
                             :api_secret => "api_secret")
        obj = instance_with_event(e, :netcfg => nc)
        assert_equal("785dba88b030f33387f70439b15cc115"+
                     "98a64c13be93c6262f8fb7913279a3d8", obj.install_signature)
      end
    end

    context "helper methods - install_body" do
      should "have working android? true" do
        obj = instance_with_event(ChartboostEvent.new(:is_android => true))
        assert_equal({"app_id"=>nil,"claim"=>1}, JSON.parse(obj.install_body))
      end

      should "have working android with gadid" do
        obj = instance_with_event(ChartboostEvent.new(:is_android => true,
                                                      :gadid => "gadid"))
        assert_equal({"gaid" => "gadid", "uuid" => "gadid",
                       "app_id" => nil, "claim" => 1},
                     JSON.parse(obj.install_body))
      end

      should "have working android with android_id" do
        obj = instance_with_event(ChartboostEvent.
                                  new(:is_android => true,
                                      :android_id => "android_id",
                                      :gadid => "gadid"))
        assert_equal({"gaid" => "gadid", "uuid" => "android_id",
                       "app_id" => nil, "claim" => 1},
                     JSON.parse(obj.install_body))
      end

      should "work if not android" do
        obj = instance_with_event(ChartboostEvent.new(:is_android => false))
        assert_equal({"ifa" => nil, "app_id"=>nil,"claim"=>1},
                     JSON.parse(obj.install_body))
      end

      should "set app_id if netcfg contains value" do
        obj = instance_with_event(ChartboostEvent.new(:is_android => false),
                                  :netcfg=>OpenStruct.new(:app_id=>"app_id"))
        assert_equal({"ifa" => nil, "app_id"=>"app_id","claim"=>1},
                     JSON.parse(obj.install_body))
      end
    end
  end
end
