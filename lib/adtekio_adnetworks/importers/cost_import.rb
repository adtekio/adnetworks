module AdtekioAdnetworks
  module Cost
    # placeholder
  end

  module CostImport
    include BaseImporter
  end
end

Dir[File.join(File.dirname(__FILE__), 'cost', '*.rb')].each do |f|
  require f
end
