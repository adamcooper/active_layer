class Persistor
  include ActiveLayer::Persistence
end
class PersistorWithValidations
  include ActiveLayer::Validations
  include ActiveLayer::Persistence
  validates :name, :presence => true
  
end
class CustomPersistor
  include ActiveLayer::Persistence
  attr_accessor :save_called
  def active_layer_save
    @save_called = true
  end
end