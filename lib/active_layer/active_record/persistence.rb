require 'active_record'

module ActiveLayer
  module ActiveRecord
    # override the initialize because the submodels should handle their own translations
    # This will allow drop in compatibility with existing functionality
    class RecordInvalid < ::ActiveRecord::RecordInvalid
    end

    module Persistence
      extend ActiveSupport::Concern

      def save!
        unless save
          raise RecordInvalid.new(self)
        end
      end
    end
  end
end
