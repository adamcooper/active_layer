class NameValidator
  include ActiveLayer::Validations
  layers :person
  validates :name, :presence => true
end

class EmailValidator
  include ActiveLayer::Validations
  validates :email, :presence => true
  validates_with NameValidator
end

class ComplexModelValidator
  include ActiveLayer::Validations
  validates :address, :presence => true
  validates_with EmailValidator
  validates_with NameValidator, :attributes => [:users]
end

class CallbackValidator
  include ActiveLayer::Validations
  before_validation :run_before
  after_validation :run_after
  validates :name, :presence => true
  
  def run_before
    active_layer_object.before += 1
  end
  def run_after
    active_layer_object.after += 1
  end
    
end

class CallbackWrapperValidator 
  include ActiveLayer::Validations
  validates :email, :presence => true
  validates_with CallbackValidator
end
class CallbackAttributeWrapperValidator 
  include ActiveLayer::Validations
  validates :email, :presence => true
  validates_with CallbackValidator
end
