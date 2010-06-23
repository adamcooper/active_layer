class ArUniquenessValidator < ActiveRecord::Validations::UniquenessValidator
  def setup(record)
    # don't set the class here...
  end
  def validate_each(record, attribute, value)
    record = record.active_layer_object if record.respond_to?(:active_layer_object)
    @klass = record.class

    super(record, attribute, value)
  end
end