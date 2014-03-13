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

     
    # model validation methods
    def errors
      if active_layer_object.respond_to?(:errors)
        active_layer_object.errors
      else
        super
      end
    end

    # Private: Preserves errors before a passed in block is executed.
    #          Then merges the preserved errors into the validator instance
    #          errors hash after the block is executed.
    #
    # prefix - optional string to prepend to error attribute's name
    #
    # Returns the value of the evaluated block

    def keep_errors(prefix = "")
      original_errors = errors.respond_to?(:messages) ? errors.messages.dup : errors.dup
      result = yield
      merge_errors(original_errors, prefix)
      result
    end

    # Private: Adds the passed in errors to the validator instance errors
    #
    # errors_to_merge_in - a hash of errors eg {:name => ['must be present']}
    # prefix - optional string to prepend to error attribute's name
    #
    # Return value not used

    def merge_errors(errors_to_merge_in, prefix = nil)
      errors_to_merge_in.each do |child_attribute, messages|
        attribute = "#{prefix}#{child_attribute}"
        errors[attribute].concat(Array(messages))
        errors[attribute].uniq!
      end
    end

    def valid?(*)
      _run_validation_callbacks do
        result = nil
        keep_errors { active_layer_object.valid? } if active_layer_object.respond_to?(:valid?) && !_validator
        keep_errors { result = super }
        errors.empty? && result
      end
    end
  end  # Validations
end # ActiveLayer
