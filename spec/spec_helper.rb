require 'rubygems'
require "bundler"
Bundler.setup

require "active_layer"

require "rspec"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
#  config.include ActiveLayer::Spec::Matchers
end