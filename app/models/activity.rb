class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :event
  validates_presence_of :date
  validates_presence_of :user
  validates_presence_of :points
  validates_presence_of :description

  field :event, :type => String
  field :date, :type => Date
  field :user, :type => String
  field :points, :type => Integer
  field :description, :type => String
end