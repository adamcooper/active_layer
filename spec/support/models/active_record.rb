require "#{File.dirname(__FILE__)}/validations"

class UserLayer
  include ActiveLayer::ActiveRecord
  attr_accessible :name
  
  validates :email, :presence => true
  validates_with NameValidator
end
