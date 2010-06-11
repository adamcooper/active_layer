class SimpleAttributes
  include ActiveLayer::Attributes
  all_attributes_accessible!
end

class ProtectedAttributes
  include ActiveLayer::Attributes
  attr_accessible :name
end
class EmptyAttributes
  include ActiveLayer::Attributes
  # empty accessible_attributes so pass nothing
end
