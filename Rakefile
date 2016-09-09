# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name        = "adtekio_adnetworks"
  gem.homepage    = "https://github.com/adtekio/adnetworks"
  gem.license     = "MIT"
  gem.summary     = %Q{Encapsulate mobile adnetworks support code.}
  gem.description = %Q{Why this gem?
The aim is to make mobile advertising and mobile user acquistion
more flexible and cost effective.

In a sense, this gem can help become your own mobile adnetwork aggregator
by allowing you to easily try out new adnetworks without having to integrate
their respective SDKs. The gem also provides the raw data for comparing the
performance of adnetworks and allowing you to make informed choices.
}
  gem.email       = "gerrit.riessen@gmail.com"
  gem.authors     = ["Gerrit Riessen"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.warning = false
end

task :default => :test

task :environment do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
  require_relative 'lib/adtekio_adnetworks'
end

desc "Start a pry shell and load all gems"
task :shell => :environment do
  require 'pry'
  Pry.editor = "emacs"
  Pry.start
end
