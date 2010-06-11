module ActiveLayer
  module Validations
    autoload :Validator, 'active_layer/validations/validator'
    autoload :EachValidator, 'active_layer/validations/each_validator'
    autoload :ObjectValidator, 'active_layer/validations/object_validator'

    extend ActiveSupport::Concern
    include ActiveLayer::Proxy
    include ActiveModel::Validations
    include ActiveLayer::Validations::Validator
    
    included do
      extend ActiveModel::Callbacks
      define_model_callbacks :validation
    end

    module InstanceMethods
     
      # model validation methods
      def errors
        if active_layer_object.respond_to?(:errors)
          active_layer_object.errors
        else
          super
        end
      end


      def keep_errors(prefix = "")
        original_errors = errors.dup
        result = yield
        merge_errors(original_errors, prefix)
        result
      end

      def merge_errors(other_errors, prefix = nil)
        other_errors.each do |child_attribute, message|
          attribute = "#{prefix}#{child_attribute}"
          errors[attribute] << message
          errors[attribute].uniq!
        end
      end

      def valid?(*)
        _run_validation_callbacks do
          super
          #keep_errors { active_layer_object.valid? }
        end
      end
    
    end

  end  # Validations
end # ActiveLayer