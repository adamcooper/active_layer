module ActiveLayer
  # This module introduces save and update_attribute methods delegating to the proxy object
  #
  # This module provides two hook methods to allow the including class to control how the attributes get set on the proxy object
  # and how the proxy object gets saved.
  #
  # Here are the defaults
  # 
  #     def active_layer_save
  #       active_layer_object.save
  #     end
  # 
  #     def active_layer_attributes_setting(new_attributes)
  #       active_layer_object.attributes = new_attributes
  #     end
  # 
  module Persistence
    extend ActiveSupport::Concern
    include ActiveLayer::Proxy
    
    module InstanceMethods
      def save
        valid = self.respond_to?(:valid?, false) ? valid? : true

        if valid
          active_layer_save
        else
          false
        end
      end
      
      def save!
        unless save
          raise RecordInvalidError.new(self)
        end
      end
      
      def update_attributes(new_attributes)
        active_layer_attributes_setting(new_attributes)
        save
      end

      def update_attributes!(new_attributes)
        active_layer_attributes_setting(new_attributes)
        save!
      end

      # hook method to override saving behaviour
      def active_layer_save
        active_layer_object.save
      end
      
      # another hook method to control attributes=
      def active_layer_attributes_setting(new_attributes)
        active_layer_object.attributes = new_attributes
      end
      
    end
  end

  class RecordInvalidError < RuntimeError
    attr_reader :record
    def initialize(record)
      @record = record
      super(@record.errors.full_messages.join(", "))
    end
  end
end