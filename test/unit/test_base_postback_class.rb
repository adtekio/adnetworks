require File.dirname(File.expand_path(__FILE__)) + '/../helper.rb'

class TestBasePostbackClass < Minitest::Test
  context "helper methods" do
    setup do
      @obj = AdtekioAdnetworks::BasePostbackClass.new(nil,nil,nil,nil)
    end

    should "have sha1 method" do
      assert_equal("9ab50f27d4201db9b28483ba83c48ebafbb2aa17",
                   @obj.sha1("fubar"))
    end

    should "have muidify" do
      assert_equal("UYXouP2KcfyAVF4UT5H68g", @obj.muidify("fubar"))
    end

    should "have parse_string" do
      assert_equal "nothing", @obj.parse_string("nothing")
      str = "[@{@event}@,<%= @params %>,@{netcfg}@]"
      assert_equal("[,,]", @obj.parse_string(str))
    end

    should "have should_handle method" do
      assert_equal true, @obj.should_handle?(OpenStruct.new)

      cfg = os(:check => "false")
      assert_equal false, @obj.should_handle?(cfg)

      cfg = os(:check => :method_not_defined)
      assert_raises NoMethodError do
        @obj.should_handle?(cfg)
      end

      cfg = os(:check => :return_true)
      @obj.instance_eval do
        def return_true
          true
        end
      end
      assert_equal true, @obj.should_handle?(cfg)
      cfg = os(:check => 'self.return_true')
      assert_equal true, @obj.should_handle?(cfg)
      cfg = os(:check => 'return_true')
      assert_equal true, @obj.should_handle?(cfg)
    end

    should "have a contains_eruby method" do
      { "@{fubar}@"    => true,
        "<% fubar %>"  => true,
        "<%= fubar %>" => true,
        "<%? fubar %>" => true,
        "<%? fubar ?>" => false,
        "<? fubar ?>"  => false,
        "@{fubar}?"    => false,
        '#{fubar}?'    => false,
      }.each do |str, exp|
        assert_equal exp, @obj.contains_eruby?(str), "Failed for #{str}"
      end
    end

    should "have either_hash_or_symbol_to_string" do
      @obj.instance_eval do
        def return_hello_world
          "hello world"
        end
      end
      assert_equal("hello world",
                   @obj.either_hash_or_symbol_to_string(:return_hello_world))
      assert_equal("hello world",
                   @obj.either_hash_or_symbol_to_string("hello world"))

      assert_equal("", @obj.either_hash_or_symbol_to_string({}))
      hsh = {
        :param1 => "one",
        :param2 => "two"
      }
      assert_equal("param1=one&param2=two",
                   @obj.either_hash_or_symbol_to_string(hsh))
    end
  end
end
