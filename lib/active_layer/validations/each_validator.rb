module ActiveLayer
  module Validations
    #
    # This class hooks into the standard validations and allows the new ActiveLayer::Validations to function 
    # as a NestedValidator
    # 
    #     class MyValidator
    #        include AciveLayer::Validations
    #        validates MyOtherValidator, :attributes => :sub_models
    #     end
    #
    #   In the above case this class will be used to adapt the MyOtherValidator to look like an ActiveModel::Validator
    #
    class EachValidator < ActiveModel::EachValidator
      attr_accessor :active_layer_validator

      #
      # The parent_validations will be the parent class that has mixed in the ActiveLayer::Validations module
      #
      def validate_each(parent_validations, attribute, value)
        nested_attribute = parent_validations.read_attribute_for_validation(attribute)

        Array.wrap(nested_attribute).each do |element|
          active_layer_validator.active_layer_object = element
          active_layer_validator.valid?
          parent_validations.merge_errors(active_layer_validator.errors, "#{attribute}.")
        end
      end
  
    end  
  end
end