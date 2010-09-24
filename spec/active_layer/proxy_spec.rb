require 'spec_helper'

module ActiveLayer
  describe Proxy do
    let(:valid_person) { Person.new('Valid Name') }
    it "should pass on any missing request to the active_record_object" do
      subject = NameValidator.new(valid_person)
      subject.name.should == 'Valid Name'
    end
    it "should properly handle respond_to?" do
      subject = NameValidator.new(valid_person)
      subject.respond_to?(:name).should be_true
    end
    it "returns the object when the layer method is called" do
      subject = NameValidator.new(valid_person)
      subject.person.should == valid_person
    end
  end
end