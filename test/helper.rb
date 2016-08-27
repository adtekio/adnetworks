require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'minitest/autorun'
require 'minitest/unit'
require 'shoulda/context'
require 'rr'
require 'pry'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'adtekio_adnetworks'

class Minitest::Test
  def dump_exception(e)
    puts "-"*20
    puts e.message
    puts "-"*20
    puts e.backtrace
    puts "-"*20
  end

  def for_all_events(&block)
    AdtekioAdnetworks::Postbacks.networks.map do |network,klz|
      klz.postbacks.map do |platform,events|
        events.map do |event|
          begin
            yield(network, klz, platform, event)
          rescue Exception => e
            dump_exception(e)
            assert(false, "Failed for #{network} / #{platform} / #{event}")
          end
        end
      end
    end
  end
end
