require 'activerecord'

module ActiveLayer
  module ActiveRecord
    # override the initialize because the submodels should handle their own translations
    # This will allow drop in compatibility with existing functionality
    class RecordInvalidError < ::ActiveRecord::RecordInvalidError
      attr_reader :record
      def initialize(record)
        @record = record
        super(@record.errors.full_messages.join(", "))
      end
    end

    module Persistence
      extend ActiveSupport::Concern
      
      module InstanceMethods

        def save!
          unless save
            raise RecordInvalidError.new(self)
          end
        end

      end
    end
  end
end