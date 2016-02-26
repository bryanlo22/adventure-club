class WallController < ApplicationController
  load_and_authorize_resource :class => :wall

  def index
    users = User.collection.aggregate([
      {
        :$project => {
          :_id => '$_id',
          :name => '$name',
          :image => '$image'
        }
      }
    ])

    @users = []
    users.each do |user|
      @users << user
    end

    user_points_collection = Activity.collection.aggregate([
      {
        :$group => {
          :_id => '$user',
          :points => {
            :$sum => '$points'
          }
        }
      }
    ])

    user_points = Hash.new(0)
    user_points_collection.each do |user|
      id = user['_id']
      user_points[id] = user['points']
    end

    @users.each do |user|
      id = user['_id'].to_s
      user['points'] = user_points[id]
    end
    @users = @users.sort_by{|user| user['points']}.reverse
  end
end