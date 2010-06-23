require 'spec_helper'

module ActiveLayer
  describe Persistence do
    subject { Persistor.new(saver) }
    let(:saver) { SavingObject.new }
    describe "active_layer_save" do
      it "by default call save on the active_layer_save" do
        saver.should_receive(:save)
        subject.save
      end
      it "allows the mixing in class to override the save process" do
        subject = CustomPersistor.new(saver)
        subject.save

        saver.save_called.should be_false
        subject.save_called.should be_true
      end
    end
    describe "save" do
      context "when the layer has validations" do 
        subject { PersistorWithValidations.new(saver) }
        it "will call valid? on the active_layer if it is present" do
          subject.should_receive(:valid?)
          subject.save
        end
        it "will not call active_layer_save if the layer isn't valid" do
          saver.name = ''
          subject.should_not_receive(:active_layer_save)
          subject.save
        end
        it "returns false when the validations fail" do
          saver.name = ''
          subject.save.should == false
        end
      end
      it "won't call valid? on the proxy object if the layer doesn't support validations" do
        saver.should_not_receive(:valid?)
        subject.save
      end
      it "returns the result of the default active_layer_save" do
        subject.stub(:active_layer_save).and_return('magic')
        subject.save.should == 'magic'
      end
    end
    describe "save!" do
      it "should raise an error if it is not valid" do
        saver.save = false
        expect {
          subject.save!
        }.to raise_error(ActiveLayer::RecordInvalid)
      end
    end
  end
end