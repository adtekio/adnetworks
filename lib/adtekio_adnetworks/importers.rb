require 'adwords_api'
require 'addressable'
require 'addressable/uri'
require 'csv'
require 'curb'
require 'mechanize'
require 'uri'
require 'net/http'
require 'net/http/persistent'
require 'net/http/digest_auth'
require 'rest-client'
require 'digest/sha1'

module AdtekioAdnetworks
  module BaseImporter
    def self.included(klz)
      klz.class_eval do
        def self.networks
          @networks
        end

        def self.register(importer_klz)
          (@networks ||= {})[importer_klz.new.network] = importer_klz
        end

        def self.included(importer_klz)
          register(importer_klz)
          importer_klz.class_eval do
            def self.define_required_credentials(&block)
              @reqcreds = yield
              self.class_eval do
                def self.required_credentials
                  @reqcreds
                end
              end
            end
          end
        end
      end
    end

    def network
      @network ||=
        self.class.name.to_s.sub(/^.+::([^:]+)$/,'\1').snakecase.to_sym
    end

    def credentials
      @credentials ||= OpenStruct.new
    end

    def credentials=(val)
      @credentials = val.is_a?(Hash) ? OpenStruct.new(val) : val
    end
  end
end

require_relative 'importers/cost_import'
require_relative 'importers/revenue_import'
