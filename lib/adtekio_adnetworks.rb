module AdtekioAdnetworks
  extend self

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    config = configuration
    block_given? ? yield(config) : config
    config
  end
end

require_relative 'adtekio_adnetworks/configuration'
require_relative 'adtekio_adnetworks/importers'
