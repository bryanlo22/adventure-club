class Position
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :title
  validates_presence_of :description

  field :title, :type => String
  field :users, :type => Array, :default => []
  field :description, :type => String
end