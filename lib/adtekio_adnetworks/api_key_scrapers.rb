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

    protected

    def _g(url)
      agent.get(url)
    end

    def get_and_match(url, regexp)
      _g(url).content =~ regexp && $1
    end

    def post_and_match(url, data, regexp)
      agent.post(url, data).content =~ regexp && $1
    end

    def return_token_hash(&block)
      { :token => yield }
    end

    def return_result_hash(&block)
      {}.tap { |result| yield(result) }
    end

    def enter_login_details(form)
      form.fields.
        select { |a| a.name =~ /[Ee]mail/ }.first.value = params["username"]
      form.fields.
        select {|a| a.name =~ /[Pp]assw(or)?d/}.first.value = params["password"]
      form
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "api_key_scrapers", '*.rb')].
  each { |f| require f }
