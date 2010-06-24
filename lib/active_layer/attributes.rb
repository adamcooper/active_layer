require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/hash/keys'

module ActiveLayer
  class UnknownAttributeError < StandardError; end

  # Adds the ability to pass attributes to the ActiveLayer Object.
  #  - Provides support for 'attr_accessible' class method to only allow certain attributes through
  #      - By default all attributes are filter out -> opt in model
  #      - You can enable all attributes passed through with 'all_attributes_accessible!'
  #  - Hooks into the ActiveLayer::Persistence module to tie in with the update_attributes
  #      - To enable this functionality, it must be inluded after the Persistence module
  module Attributes
    extend ActiveSupport::Concern
    include ActiveLayer::Proxy

    included do
      class_attribute :accessible_attributes
      self.accessible_attributes = []
    end
    
    module ClassMethods
      def attr_accessible(*attributes)
        self.accessible_attributes = Set.new(attributes.map(&:to_s)) + (accessible_attributes || [])
      end
      
      def all_attributes_accessible!
        self.accessible_attributes = nil
      end
      
    end
    
    module InstanceMethods

      def attributes=(new_attributes)
        return if new_attributes.nil?
        attributes = new_attributes.stringify_keys

        safe_attributes = if accessible_attributes.nil? 
          attributes
        else
          attributes.reject { |key, value| !accessible_attributes.include?(key.gsub(/\(.+/, "")) }
        end
        
        safe_attributes.each do |k, v|
          respond_to?(:"#{k}=") ? send(:"#{k}=", v) : raise(UnknownAttributeError, "unknown attribute: #{k}")
        end
      end
      
      # override persistence saving to pull in the guard functionality
      def active_layer_attributes_setting(new_attributes)
        self.attributes = new_attributes
      end
      
      
    end # InstanceMethods
  end # Attributes
end # ActiveLayer
