require 'spec_helper'

module ActiveLayer
  describe Validations do

    describe "standard validations" do
      let(:valid_person) { Person.new('Valid Name') }
      let(:invalid_person) { Person.new() }
  
      it "check the passed in model and return true if it's valid" do
       subject = NameValidator.new(valid_person)
       subject.should be_valid
      end
      it "should show that an invalid model isn't valid" do
        subject = NameValidator.new(invalid_person)
        subject.should be_invalid
      end
      context "when the base object has validations" do
        it "will call valid? on the underlying object" do
          user = Admin.new
          subject = NameValidator.new(user)
          user.should_receive(:valid?)
          subject.valid?
        end
        it "will propogate up the errors on the base object" do
          user = UserWithValidations.new
          subject = NameValidator.new(user)
          subject.valid?
          subject.errors[:email].should be_present
          subject.errors[:name].should be_present
        end
        it "will keep all the errors on the base object" do
          user = UserWithValidations.new
          subject = NameValidator.new(user)
          subject.valid?
          user.errors[:email].should be_present
          user.errors[:name].should be_present
        end
        it "should expose the errors on the validator" do
          subject = NameValidator.new(invalid_person)
          subject.valid?
          subject.errors[:name].should be_present
        end
        it "should also exposes the errors on the object if it has error support" do
          user = Admin.new
          subject = NameValidator.new(user)
          subject.valid?
          user.errors[:name].should be_present
        end
      end
    end
  
    describe "included Validations" do
      subject { EmailValidator.new(admin) }
      let(:admin) { Admin.new }
    
      it "should validate on all the fields" do
        subject.valid?
        subject.errors[:name].should be_present
        subject.errors[:email].should be_present
      end
    
      it "should leave the correct errors on the object" do
        subject.valid?
        admin.errors[:name].should be_present
        admin.errors[:email].should be_present
      end
    end
  
    describe "ComplexValidator" do
      subject { ComplexValidator.new(complex) }
      let(:complex) { Complex.new }
      let(:user) { Admin.new }
      let(:users) { [user, Admin.new]}
    
      context "checking the ComplexValidator defined validations" do
        it "should return the correct validation errors" do
          subject.should_not be_valid
          subject.errors[:address].should be_present
        end
      end
      context "checking the included validations" do
        it "should return the correct validation errors" do
          subject.valid?
          subject.errors[:name].should be_present
          subject.errors[:email].should be_present
        end
      end
      context "checking the NestedArray defined validations" do
        it "should set the errors on a child records" do
          complex.users = users
          subject.valid?
          user.errors[:name].should be_present
          users.last.errors[:name].should be_present
        end
        it "should work on a single child record" do
          complex.users = user
          subject.valid?
          user.errors[:name].should be_present
        end
        it "should bubble the errors up to the parent only once" do
          complex.users = users
          subject.valid?
          subject.errors[:"users.name"].should be_present
          subject.errors[:"users.name"].size.should == 1
        end
        it "should work with nested objects without errors" do
          complex.users = [AdminNoError.new, AdminNoError.new]
          subject.valid?
          subject.errors[:"users.name"].should be_present
        end
      end
  
    end
  
    describe "callback validations" do
      let(:admin) { Admin.new.tap {|x| x.before = 0; x.after = 0} }
      subject { CallbackValidator.new(admin) }
      it "should run the before callback" do
        subject.valid?
        admin.before.should == 1
      end
      it "should run the after callback if the model is valid" do
        admin.name = 'name'
        subject.valid?
        admin.after.should == 1
      end
      it "should not run the after callback if the model is not valid" do
        admin.name = ''
        subject.should_not be_valid
        admin.after.should == 0
      end
      context "as a nested validation" do
        subject { CallbackWrapperValidator.new(admin) }
        it "should run the before callback" do
          subject.valid?
          admin.before.should == 1
        end
        it "should run the after callback" do
          admin.name = 'name'
          subject.valid?
          admin.after.should == 1
        end
        it "should not run the after callback if the model is not valid" do
          admin.name = ''
          subject.should_not be_valid
          admin.after.should == 0
        end
      end
    end
  
  end
end