#
# This class hooks into the standard validations and allows the new ModelValidator to function 
# as a NestedValidator
#
module ActiveLayer
  module Validations
    class ObjectValidator < ActiveModel::Validator
      attr_accessor :active_layer_validator

      def validate(record)
        # need to save the original errors because they get wiped during validation
        record.keep_errors do
          active_layer_validator.active_layer_object = record
          active_layer_validator.valid?
        end
      end
    end  
  end
end