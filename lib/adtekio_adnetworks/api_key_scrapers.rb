require 'mechanize'

module AdtekioAdnetworks
  class ApiKeyScrapers
    attr_reader :agent, :params

    def initialize
      @agent = Mechanize.new
      @agent.user_agent_alias = 'Mac Mozilla'
    end

    def obtain_key_for(network, params)
      @params = params
      send("key_for_#{network}")
    end

    def self.supporter_adnetworks
      public_instance_methods.
        select { |a| a =~ /key_for_/ }.map { |a| a.to_s.sub(/key_for_/,'') }
    end

    protected

    def _g(url)
      agent.get(url)
    end

    def _p(url, data)
      agent.post(url, data)
    end

    def get_and_match(url, regexp)
      _g(url).content =~ regexp && $1
    end

    def post_and_match(url, data, regexp)
      _p(url, data).content =~ regexp && $1
    end

    def return_result_hash(&block)
      {}.tap { |result| yield(result) }
    end

    def return_token_hash(&block)
      return_result_hash { |r| r[:token] = yield }
    end

    def enter_login_details(form)
      form.fields.
        select { |a| a.name =~ /email/i }.first.value = params["username"]
      form.fields.
        select {|a| a.name =~ /passw(or)?d/i}.first.value = params["password"]
      form
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "api_key_scrapers", '*.rb')].
  each { |f| require f }
