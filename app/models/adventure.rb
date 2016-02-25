class Adventure
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :type
  validates_presence_of :location
  validates_presence_of :date
  validates_presence_of :participants

  field :type, :type => String
  field :photo, :type => String
  field :location, :type => String
  field :date, :type => Date
  field :heroes, :type => Array, :default => []
  field :villains, :type => Array
  field :participants, :type => Array
end