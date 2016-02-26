class PositionController < ApplicationController
  load_and_authorize_resource :position

  def index
    positions = Position.collection.aggregate([
      {
        :$project => {
          :_id => '$_id',
          :title => '$title',
          :user_ids => '$users',
          :description => '$description'
        }
      }
    ])

    @positions = []
    positions.each do |position|
      @positions << position
    end

    users = User.get_users

    @positions.each do |position|
      names = position['user_ids'].map{|id| users[id][:name]}
      position['users'] = names.join('<br>').html_safe
    end
  end

  def new
    @position = Position.new
    @users = User.all.sort_by{|user| user.name}
    @path = create_position_path
    render 'form'
  end

  def edit
    @position = Position.where(:id => params[:id]).first
    @users = User.all.sort_by{|user| user.name}
    @path = update_position_path
    render 'form'
  end

  def create
    position = Position.new
    handle(position)
  end

  def update
    position = Position.where(:id => params[:id]).first
    handle(position)
  end

  def handle(position)
    position.title = params[:title]
    position.users = params[:users] || []
    position.description = params[:description]
    changes = position.changes
    position.save!
    Audit.create!(:user => current_user.id.to_s, :type => 'position', :modifications => changes)
    redirect_to position_path
  end

end