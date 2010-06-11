module MethodTester
  def test_method(*names)
    Array.wrap(names).each do |name|
      ivar_name = name.to_s.gsub(/[^a-zA-Z]/, '')
      ivar = "@#{ivar_name}"
      ivar_called = "@#{ivar_name}_called"

      class_eval <<-EOS
        attr_accessor :#{ivar_name}, :#{ivar_name}_called

        def #{name}
          #{ivar} = true
          #{ivar_called}.nil? ? true : #{ivar}
        end
      EOS
    end
  end
end

class User
  include ActiveModel::Validations
  attr_accessor :email, :name, :address


  extend MethodTester
  test_method :save
end

class Person < Struct.new(:name, :email)
end

class Admin
  include ActiveModel::Validations
  attr_accessor :name, :email, :before, :after
  def initialize(*)
    @before = 0
    @after = 0
  end
    
end

class AdminNoError
  attr_accessor :name, :email
end

class Complex
  attr_accessor :address, :users, :email, :name
end 

class SavingObject
  attr_accessor :name
  extend MethodTester
  test_method :save, :valid?
end
class FailingObject
  extend MethodTester
  test_method :save
  def initialize
    @save = false
  end

end