require 'spec_helper'

module ActiveLayer

  describe Attributes do
    subject { SimpleAttributes.new(active_object) }
    let(:active_object) { Person.new('full name', 'email address') }

    it "should pass any attributes onto the actual model" do
      subject.attributes = {:name => 'new name', :email => 'new address'}
      active_object.name.should == 'new name'
      active_object.email.should == 'new address'
    end

    describe "attribute filters" do
      subject { ProtectedAttributes.new(active_object) }

      it "should only pass the name attribute" do
        subject.attributes = {:name => 'new name', :email => 'new address'}
        active_object.name.should == 'new name'
        active_object.email.should == 'email address'
      end
      
      it "should pass nothing by default" do
        subject = EmptyAttributes.new(active_object)
        subject.attributes = {:name => 'new name', :email => 'new address'}
        active_object.name.should == 'full name'
        active_object.email.should == 'email address'
      end
    end
    describe "active_layer_setting_attributes" do
      subject { ProtectedAttributes.new(active_object) }
      it "should properly set the attributes" do
        subject.active_layer_attributes_setting(:name => 'new name', :email => 'new address')
        active_object.name.should == 'new name'
        active_object.email.should == 'email address'
      end
    end
  end

end