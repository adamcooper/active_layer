require 'active_support'
require 'active_model'
require 'active_layer/version' unless defined?(ActiveLayer::VERSION)

module ActiveLayer
  autoload :ActiveRecord, 'active_layer/active_record'
  autoload :Attributes, 'active_layer/attributes'
  autoload :Persistence, 'active_layer/persistence'
  autoload :Proxy, 'active_layer/proxy'
  autoload :Validations, 'active_layer/validations'
end

