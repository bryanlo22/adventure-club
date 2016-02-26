class WallController < ApplicationController
  load_and_authorize_resource :class => :wall

  def index
    @users = User.collection.aggregate([
      {
        :$project => {
          :_id => '$_id',
          :name => '$name',
          :image => '$image'
        }
      }
    ]).map{|user| user}

    heroes_collection = Adventure.collection.aggregate([
      {
        :$unwind => '$heroes'
      },
      {
        :$group => {
          :_id => '$heroes',
          :count => {
            :$sum => 1
          }
        }
      }
    ]).map{|hero| hero}

    participants_collection = Adventure.collection.aggregate([
      {
        :$unwind => '$participants'
      },
      {
        :$group => {
          :_id => '$participants',
          :count => {
            :$sum => 1
          }
        }
      }
    ]).map{|participants| participants}

    user_points_collection = Activity.collection.aggregate([
      {
        :$group => {
          :_id => '$user',
          :points => {
            :$sum => '$points'
          }
        }
      }
    ]).map{|activity| activity}

    user_points = Hash.new(0)
    user_points_collection.each do |user|
      id = user['_id']
      user_points[id] = user['points']
    end

    heroes_collection.each do |hero|
      id = hero['_id']
      user_points[id] += 2 * hero['count']
    end

    participants_collection.each do |participants|
      id = participants['_id']
      user_points[id] += 1 * participants['count']
    end

    @users.each do |user|
      id = user['_id'].to_s
      user['points'] = user_points[id]
    end
    @users = @users.sort_by{|user| user['points']}.reverse

    @notables = []
    users = User.get_users

    max_hero_times = heroes_collection.sort_by{|hero| hero['count']}.last['count']
    superheroes = heroes_collection.select{|hero| hero['count'] == max_hero_times}
    superheroes.each do |hero|
      id = hero['_id']
      count = hero['count']
      @notables << {
        :image => users[id][:image],
        :name => users[id][:name],
        :award => 'Superhero',
        :stat => "#{count} adventures"
      }
    end

    max_vet_times = participants_collection.sort_by{|participant| participant['count']}.last['count']
    veteran_adventurer = participants_collection.select{|participant| participant['count'] == max_vet_times}
    veteran_adventurer.each do |vet|
      id = vet['_id']
      count = vet['count']
      @notables << {
        :image => users[id][:image],
        :name => users[id][:name],
        :award => 'Veteran',
        :stat => "#{count} adventures"
      }
    end

    negative_points_collection = Activity.collection.aggregate([
      {
        :$match => {
          :points => {
            :$lt => 0
          }
        }
      },
      {
        :$group => {
          :_id => '$user',
          :points => {
            :$sum => '$points'
          }
        }
      }
    ])
    negative_points = Hash.new(0)
    negative_points_collection.each do |user|
      id = user['_id']
      negative_points[id] = user['points']
    end
    min_points = negative_points.min_by{|id, points| points}[1]
    goofballs = negative_points_collection.select{|user| user['points'] == min_points}
    goofballs.each do |goof|
      id = goof['_id']
      count = goof['points']
      @notables << {
        :image => users[id][:image],
        :name => users[id][:name],
        :award => 'Goofball',
        :stat => "#{-count} points lost"
      }
    end

  end
end