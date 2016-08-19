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
        end
      end
    end

    def network
      @network ||= self.class.name.downcase.sub(/^.+::([^:]+)$/,'\1').to_sym
    end

    def credentials
      @credentials ||= OpenStruct.new
    end

    def credentials=(val)
      @credentials = val
    end
  end
end

require_relative 'importers/cost_import'
require_relative 'importers/revenue_import'
