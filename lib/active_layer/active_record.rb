module ActiveLayer
  # This is a helper module that is only responsible for pulling in all the modules
  module ActiveRecord
    autoload :Persistence, 'active_layer/active_record/persistence'

    extend ActiveSupport::Concern

    include ::ActiveLayer::Validations
    include ::ActiveLayer::Persistence 
    include ::ActiveLayer::Attributes  # hook in after the Persistence layer

    # we only need this if ActiveRecord is actually defined.
    include ::ActiveLayer::ActiveRecord::Persistence if defined?(::ActiveRecord)
    
  end
end