require File.dirname(File.expand_path(__FILE__)) + '/../helper.rb'
require 'ostruct'

class TestPostbacksDefinition < Minitest::Test
  class TestKlz < AdtekioAdnetworks::BasePostbackClass
    include AdtekioAdnetworks::BasePostbacks

    define_network_config do
      [:appid,:source]
    end

    define_postback_for :all, :mac do
      { :url => "http://getap.ps/callback.php/@{params.fubar}@",
        :params => {
          :appid  => "@{netcfg.appid}@",
          :idfa   => "@{event.adid}@",
          :ip     => "@{event.ip}@",
          :source => "@{netcfg.source}@"
        },
        :header => {
          "x-fubar" => "@{get_header_value}@"
        }
      }
    end

    define_postback_for :all, :mac do
      { :url => "http://getap.ps/callback.php/second_url",
        :params => {
        },
        :post => {
          :fubar        => "@{get_value}@",
          :snafu        => "@{event.post_value}@",
          :symbol_value => :is_not_evaluated
        }
      }
    end

    define_postback_for(:ios, :pay) do
      {
        :store_user => true
      }
    end

    define_postback_for(:android, :pay) do
      {
        :user_required => true,
        :store_user => false
      }
    end

    def get_value
      event.post_value
    end

    def get_header_value
      (params && params.header && params.header[:value])
    end
  end

  context "postback defintions" do
    should "have a user required class method" do
      assert !TestKlz.user_required?(:mac, :all)
      assert !TestKlz.user_required?(:pay, :ios)
      assert TestKlz.user_required?(:pay, :android)
    end

    should "have a store user class method" do
      assert !TestKlz.store_user?(:mac, :all)
      assert TestKlz.store_user?(:pay, :ios)
      assert !TestKlz.store_user?(:pay, :android)
    end

    should "have a network name" do
      assert_equal(:"test_klz", TestKlz.network)
    end

    should "have a list of postbacks" do
      assert_equal({:all=>[:mac, :mac], :ios => [:pay], :android => [:pay]},
                   TestKlz.postbacks)
    end

    should "have class method for returning url" do
      assert_equal(["http://getap.ps/callback.php/@{params.fubar}@"+
                    "?appid=@{netcfg.appid}@&idfa=@{event.adid}@&ip="+
                    "@{event.ip}@&source=@{netcfg.source}@",
                    "http://getap.ps/callback.php/second_url"],
                   TestKlz.mac(:all).map{|a| a[:url]})
    end

    should "be in the list of available networks" do
      assert_equal TestKlz, AdtekioAdnetworks::Postbacks.networks[:test_klz]
    end

    should "generate a url" do
      e      = OpenStruct.new(:ip => "IP", :adid => "ADID",
                              :post_value => "POST_VALUE")
      nc     = OpenStruct.new(:appid => "APPID", :source => "SOURCE")
      user   = OpenStruct.new
      params = OpenStruct.new(:fubar => "FUBAR", :header => {:value => "VALUE"})
      r = TestKlz.new(e, user, nc, params).mac(:all)

      assert_equal("http://getap.ps/callback.php/FUBAR?appid=APPID&"+
                   "idfa=ADID&ip=IP&source=SOURCE", r.first[:url])
      assert_equal("", r.first[:body])
      assert_equal({"x-fubar"=>"VALUE" }, r.first[:header])

      assert_equal "http://getap.ps/callback.php/second_url", r.last[:url]
      assert_equal("fubar=POST_VALUE&snafu=POST_VALUE&"+
                   "symbol_value=is_not_evaluated", r.last[:body])
      assert_equal({}, r.last[:header])
    end
  end
end
