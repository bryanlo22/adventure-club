class HomeController < ApplicationController
  load_and_authorize_resource :class => :home

  def index
    search = {}
    handle(search)
  end

  def bike
    search = {:type => 'Bike'}
    handle(search)
  end

  def hike
    search = {:type => 'Hike'}
    handle(search)
  end

  def handle(search)
    adventures = Adventure.collection.aggregate([
      {
        :$match => search
      },
      {
        :$sort => {
          :date => 1
        }
      },
      {
        :$project => {
          :_id => '$_id',
          :photo => '$photo',
          :location => '$location',
          :date => '$date',
          :hero_ids => '$heroes',
          :villain_ids => '$villains',
          :participant_ids => '$participants'
        }
      }
    ])

    @adventures = []
    adventures.each do |adventure|
      adventure['date'] = adventure['date'].to_date.strftime('%B %d, %Y') unless adventure['date'].nil?
      @adventures << adventure
    end

    user_names = User.get_user_names

    @adventures.each do |adventure|
      if adventure['hero_ids'].present?
        heroes = adventure['hero_ids'].map{|id| user_names[id]}
        adventure['heroes'] = heroes.join('<br>').html_safe
      end
      if adventure['villain_ids'].present?
        heroes = adventure['villain_ids'].map{|id| user_names[id]}
        adventure['villains'] = villains.join('<br>').html_safe
      end
      if adventure['participant_ids'].present?
        participants = adventure['participant_ids'].map{|id| user_names[id]}
        adventure['participants'] = participants.join('<br>').html_safe
      end
    end

    if current_user.nil?
      render 'sign_in', :layout => 'basic'
    elsif current_user.roles.present?
      render 'index'
    else
      render 'member_only', :layout => 'basic'
    end
  end
end
