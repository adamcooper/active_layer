module ActiveLayer
  module Validations
    # This module allows the ActiveLayer::Validations class to adapt to become
    # an ActiveModel Validator
    module Validator
      extend ActiveSupport::Concern
      
      included do
        attr_accessor :_validator
      end
      
      module InstanceMethods

        def initialize(*args, &block)
          if args.first.is_a?(Hash)
            options = args.first
            if options.has_key?(:attributes)
              self._validator = EachValidator.new(options)
            else
              self._validator = ObjectValidator.new(options)
            end
            _validator.active_layer_validator = self
          end
          super 
        end

        # adapter methods
        def setup(record)
          # nothing to do...
        end

        # adapter methods
        def attributes
          _validator && _validator.respond_to?(:attributes) ? _validator.attributes : []
        end

        def errors
          if _validator
            @errors ||= ActiveModel::Errors.new(self)
          else
            super
          end
        end
        
        # This method is called in two contexts, as part of the validation callbacks when it's setup
        # as an adapter and to register a standard callback
        #
        def validate(*args, &block)
          # puts "calling validate on #{self.class.name}"
          if _validator
            _validator.validate(*args, &block)
          else
            super
          end
        end
        

      end
      
      
      
    end
  end
end
