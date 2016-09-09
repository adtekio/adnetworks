module AdtekioAdnetworks
  module Revenue
    # placeholder
  end

  module RevenueImport
    include BaseImporter

    def check_version!(version, expected_version)
      raise "Unsupported version: #{version}" if version != expected_version
    end

    def check_currency!(currency, expected_currency)
      raise "Unsupported currency: #{currency}" if currency != expected_currency
    end

    def not_matched(hsh)
      uri = Addressable::URI.new
      uri.query_values = hsh
      uri.query
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'revenue', '*.rb')].each do |f|
  require f
end
