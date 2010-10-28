# ActiveLayer

ActiveLayer provides a simple way to apply a set of validations, attribute filtering to your models. 

ActiveRecord and other ORM validations are great for simple/ and relatively complex scenarios but they can very quickly become overloaded.  ActiveLayer takes the approach that you might not want to have 'all' your validations in the model all the time.  You might want to have a different set of accessible attributes for different classes of users.


# Quick Example

		class User < ActiveRecord::Base; end
		# Every user field you want.. 
		
		# This layer uses the ActiveRecord adapter which pulls in several other pieces
		class UserLayer
			include ActiveLayer::ActiveRecord
			
			attr_accessible :name, :email, :address
			
			validates :name, :email, :presence => true
			validates :address_validation
			
			before_validate :normalize_address
			
			def normalize_address; end
			def address_validation
				errors.add(:address, :invalid) if address.blank?
			end
		end
		
		# Now how to use it:
		user = User.find(1)
		layer = UserLayer.new(user)
		layer.update_attributes( {:name => '', :admin => true, :address => 'on a busy road'} )   # => false
		layer.errors[:name].present # => true
		user.errors[:name].present => true
		user.admin  # => false   - was filtered out
		
# Some of the players

 * ActiveLayer::Proxy
 * ActiveLayer::Validations
 * ActiveLayer::Attributes
 * ActiveLayer::Persistence

# ActiveLayer::Proxy

This module provides the ability to delegate method calls down to the object and typically you would not use this element directly.  However, it does provide one key method *active__layer__object* which provides access to the underlying object/model.  This may be necessary in certain cases.

This module also brings in the *layers* method which provides a friendly accessor for the *active_layer_object*

# ActiveLayer::Validations

Currently the majority of the functionality resides in this module and provides the ability for composable validation classes to be layered together.  This module is completely compatible with the wonderful ActiveModel::Validation module and in fact just wraps it and provides extra functionality.

Currently the following is supported:

 * Standard ActiveModel::Validators support (Each, With, Custom, etc.)
 * Custom validation methods
 * before_validation and after_validation hooks  (Just like ActiveRecord)
 * Nested ActiveLayer validations  (This is neat!)
 * All existing custom validators should 'just work'

## Examples

		class AddressValidator
			include ActiveLayer::Validations

			before_validation :normalize_address
			validates :address, :presence => true
			validate :custom_method
	
			def normalize_address; end
			def custom_method; end
		end
		
		class EmailValidator
			include ActiveLayer::Validations
			
			validates :email, :presence => true
		end

		class UserValidator
			include ActiveLayer::Validations
			
			validates :name, :presence => true
			validates_with EmailValidator 
			validates_with AddressValidator, :attributes => [:addresses]
		end
		
		# the EmailValidator will get passed the user object
		# the AddressValidator will get passed each address of the user and merge the errors back up
		user = User.find(1)
		validator = UserValidator.new(user)
		validator.valid?   # => true/false
		
		
# ActiveLayer::Attributes

This module provides the ability to bulk assign attributes with attribute protection via att_accessible.  By default all attributes are not assignable and you must declare which attributes are accessible.  Note, each attribute is available for individual assigning or reading.

## Examples

		class FlawedUserFilter
			all_attributes_accessible!
			# All attributes are now assignable
		end
		
		class UserFilter
			attr_accessible :name, :address
		end
		
		user = User.find(1)
		filter = UserFilter.new(user)
		filter.attributes = {:name => 'Bob', 'admin' => true}
		user.admin  #  => false
		



# ActiveLayer::Persistence

This layer is responsible for providing the save and update_attributes methods that function very similar to ActiveRecord.  Both layers invoke the validations in the layer, if currently mixed in and ultimately delegate to the proxy object for saving.  If the Attributes module is mixed in then the guards will be used however, if it is not mixed then active_layer_object.attributes=(hash) will be invoked.

 Note: If you plan to use Persistence with Attributes then you must mix-in the Attributes module *after* the Persistence module

## Examples

		class UserPersistor
			include ActiveLayer::Persistence
		end
	
		user = User.find(1)
		persistor = UserPersistor.new(user)
		persistor.save
		persistor.save!  # will raise an ActiveLayer::RecordInvalidError with a #record method
		persistor.update_attributes(:name => 'new')
		persistor.update_attributes!(:name => 'new')



# TODO / Plans

 * Ensure that the valid? method calls the underlying proxy object.valid?
 * Nested attribute support - similar to Rails - but in an adaptable manner for use in other ORMs
 * Add support for additional ORMs
 * Ideas?

# License

ActiveLayer is available under the terms of the MIT license (see
LICENSE.txt for details).

