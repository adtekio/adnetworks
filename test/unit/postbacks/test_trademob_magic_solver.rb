require File.dirname(File.expand_path(__FILE__)) + '/../../helper.rb'

module Postbacks
  class TestTrademobMagicSolver < Minitest::Test
    def test_klazz
      AdtekioAdnetworks::Postbacks::TrademobMagicSolver
    end

    context "post body construction" do
      should "have body" do
        nc     = os(:partner_id => "partner_id")
        params = os(:locale => "locale")
        event  = os(:uuid => "uuid")
        obj    = instance_with_event(event, :params => params, :netcfg => nc)

        r = obj.mac(:ios).first
        assert_equal("lang=&locale=locale&partner_id=partner_id&udid=uuid",
                     r[:body])
        assert_equal("http://api.magicsolver.com/iphone/apps/"+
                     "free_app_magic/register_udid/", r[:url])
      end
    end
  end
end
