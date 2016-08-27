require 'uuidtools'
require 'json'
require 'digest/sha2'
require 'digest/md5'
require 'erubis'
require 'active_support'
require 'active_support/core_ext'

module AdtekioAdnetworks
  module Postbacks
    extend self

    PossibleEvents =  {
      :mac => "Attribution",
      :ist => "Application Install",
      :apo => "Application Open",
      :fun => "Tutorial",
      :pay => "Payment",
      :eor => "End of Round",
      :scs => "Scene Start",
      :scc => "Scene Complete",
    }

    def networks
      @networks ||= {}
    end

    def register(postback_klz)
      networks[postback_klz.network] = postback_klz
    end
  end

  class BasePostbackClass
    attr_reader :event, :params, :user, :netcfg

    class CGIEruby < Erubis::PI::Eruby
      REGEXP = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]").freeze

      def escaped_expr(code)
        "URI.encode((#{code.strip}).to_s, CGIEruby::REGEXP)"
      end
    end

    class MD5 < Digest::MD5
      class << self
        alias orig_new new
        def new(str = nil)
          str ? orig_new.update(str) : orig_new
        end

        def md5(*args)
          new(*args)
        end
      end
    end

    def initialize(event, user, netcfg, params = nil)
      @event  = event
      @params = params || (event && event.params)
      @user   = user
      @netcfg = netcfg
    end

    def sha1(value)
      Digest::SHA1.hexdigest(value || "")
    end

    def muidify(val)
      Base64.encode64(MD5.md5(val).digest).tr("+/=", "-_\n").strip
    end

    def contains_eruby?(val)
      val && !!(val =~ /@\{.*\}@/ || val =~ /<%.*%>/m)
    end

    def parse_string(str)
      contains_eruby?(str) ? CGIEruby.new(str).result(binding) : str
    end

    def should_handle?(cfg)
      cfg.check.nil? ||
        !!(cfg.check.is_a?(Symbol) ? send(cfg.check) : eval(cfg.check))
    end

    def either_hash_or_symbol_to_string(val)
      if val.is_a?(Hash)
        uri = Addressable::URI.new
        uri.query_values = val
        CGI.unescape(uri.to_s).gsub(/^[?]/,'')
      elsif val.is_a?(Symbol)
        send(val)
      else
        val.to_s
      end
    end

    def cfg_to_url(cfg)
      return unless should_handle?(cfg)

      header = either_hash_or_symbol_to_string(cfg.header)
      body   = either_hash_or_symbol_to_string(cfg.post)

      urlparams = ( (cfg.params.is_a?(Hash) && cfg.params) ||
                    cfg.params.is_a?(Symbol) && send(cfg.params) ) || {}

      uri = Addressable::URI.parse(cfg.url)
      uri.query_values = urlparams unless urlparams.empty?
      url = CGI.unescape(uri.to_s)

      parsed_header = CGI::parse(parse_string(header) || "")
      parsed_header.each { |key, value| parsed_header[key] = value.first }

      { :url    => parse_string(url),
        :body   => parse_string(body),
        :header => parsed_header}
    end
  end

  module BasePostbacks
    def self.included(klz)
      klz.class_eval do
        def self.postbacks
          @postbacks ||= Hash.new{ |k,v| k[v] = [] }
        end

        def self.pbcfg
          @pbcfg ||= Hash.new{ |k,v| k[v] = Hash.new{ |k,v| k[v] = [] }}
        end

        def self.define_network_config(&block)
          @network_config = yield
          self.class_eval do
            def self.netcfg
              @network_config
            end
          end
        end

        def self.define_postback_for(platform, type, &block)
          cfg = OpenStruct.new(yield)

          postbacks[platform] << type.to_sym
          pbcfg[platform][type.to_sym] << cfg

          self.send(:define_method, type, Proc.new do |platform|
                      pbc = self.class.instance_variable_get("@pbcfg")
                      pbc[platform.to_sym][type.to_sym].map do |cfg|
                        cfg_to_url(cfg)
                      end.compact
                    end)

          self.class.send(:define_method, type, Proc.new do |platform|
                            @pbcfg[platform.to_sym][type.to_sym].map do |cfg|
                              cfg_to_description(cfg)
                            end
                          end)
        end

        def self.cfg_to_description(cfg)
          url = if cfg.params.is_a?(Hash)
            uri = Addressable::URI.parse(cfg.url)
            uri.query_values = cfg.params unless cfg.params.empty?
            CGI.unescape(uri.to_s)
          else
            "%s?%s" % [cfg.url, cfg.params.to_s]
          end

          { :url           => url,
            :user_required => cfg.user_required || false,
            :store_user    => cfg.store_user || false }
        end

        def self.user_required?(event, platform)
          self.send(event, platform).any? { |desc| desc[:user_required] }
        end

        def self.store_user?(event, platform)
          self.send(event, platform).any? { |desc| desc[:store_user] }
        end

        def self.network
          name.to_s.sub(/^.+::([^:]+)$/,'\1').snakecase.to_sym
        end
      end

      Postbacks.register(klz)
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'postbacks', '*.rb')].each do |f|
  require f
end
