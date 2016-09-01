require File.dirname(File.expand_path(__FILE__)) + '/../helper.rb'

class TestCostImporters < Minitest::Test
  context "basics" do
    should "have required_credentials" do
      for_all_cost_importers do |network, klz|
        assert(!klz.required_credentials.empty?,
               "Failed: req. cred. empty for #{network}")
      end
    end
  end
end
