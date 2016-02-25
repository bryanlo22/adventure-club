class Audit
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user, :type => String
  field :type, :type => String
  field :modifications, :type => Hash
end