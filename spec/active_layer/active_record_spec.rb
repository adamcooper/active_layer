require 'spec_helper'

module ActiveLayer
  describe ActiveRecord do
    subject { UserLayer.new(user) }
    let(:user) { User.new.tap {|user| user.email = 'email'; user.name = 'first_name'} }
    describe "validations" do
      it "should apply the correct validations when the object is invalid" do
        user.email = nil
        subject.should_not be_valid
        subject.errors[:email].should be_present
        user.errors[:email].should be_present
      end
      it "should apply the correct validations when the object is valid" do
        subject.should be_valid
        subject.errors[:email].should be_blank
        user.errors[:email].should be_blank
      end
      context "nested object validations" do
        it "should not be valid if the first_name is missing" do
          user.name = nil
          subject.should_not be_valid
          subject.errors[:name].should be_present
          user.errors[:name].should be_present
        end
        it "should keep errors from the nested validator and the current validations" do
          user.name = nil
          user.email = nil
          subject.should_not be_valid
          user.errors[:name].should be_present
          user.errors[:email].should be_present
        end
      end
      
    end
    describe "attribute passing" do
      it "should only pass what is marked as accessible" do
        user.name, user.address = 'original', 'original'
        attributes = {:name => 'new name', :address => 'new address'}

        subject.attributes = attributes
        user.name.should == attributes[:name]
        user.address.should == 'original'
      end
    end
    
  end
end
