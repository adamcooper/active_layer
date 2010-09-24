module ActiveLayer
  # This class provides the delegation to the actual object.
  # You probably don't want to use this object directly but rather the other classes depend on it.
  module Proxy
    extend ActiveSupport::Concern
    
    included do
      attr_writer :active_layer_object
    end
    
    module ClassMethods
      # Provides convenient access to the active_layer_object
      def layers(*names)
        Array.wrap(names).each do |name| 
          class_eval <<-EOS
            def #{name}
              @active_layer_object
            end
          EOS
        end
      end
    end
    
    module InstanceMethods
      def initialize(*args, &block)
        self.active_layer_object = args.first
        super()
      end  
      
      def active_layer_object
        raise "active_layer_object was not set" if @active_layer_object.nil?
        @active_layer_object
      end
      
      def method_missing(method, *args, &block)
        # puts "passing: #{method} + #{args.inspect} to #{active_layer_object.inspect}"
        unless @active_layer_object.nil?
          active_layer_object.send(method, *args, &block)
        else
          super
        end
      end
      
      def read_attribute_for_validation(key)
        if active_layer_object.respond_to?(:read_attribute_for_validation)
          active_layer_object.read_attribute_for_validation(key)
        else
          active_layer_object.send(key)
        end
      end
    
      def respond_to?(method, use_proxy = true)
        super(method) || ( use_proxy && @active_layer_object && @active_layer_object.respond_to?(method) )
      end
      
      
    end
    
  end
end