class AdventureController < ApplicationController
  load_and_authorize_resource :adventure

  def adventure_params
    params.require(:adventure).permit(:photo, :type, :location, :adventure, :heroes, :participants)
  end

  def index

  end

  def new
    @adventure = Adventure.new
    @users = User.all.sort_by{|user| user.name}
    @path = create_adventure_path
    render 'form'
  end

  def edit
    @adventure = Adventure.where(:id => params[:id]).first
    @date = @adventure.date.strftime('%B %d, %Y')
    @users = User.all.sort_by{|user| user.name}
    @path = update_adventure_path
    render 'form'
  end

  def create
    adventure = Adventure.new
    handle(adventure)
  end

  def update
    adventure = Adventure.where(:id => params[:id]).first
    handle(adventure)
  end

  def handle(adventure)
    adventure.photo = params[:photo]
    adventure.type = params[:type]
    adventure.location = params[:location]
    adventure.date = params[:adventure]['date'].to_date
    adventure.heroes = params[:heroes] || []
    adventure.participants = params[:participants] || []
    changes = adventure.changes
    adventure.save!
    Audit.create!(:user => current_user.id.to_s, :type => 'Adventure', :modifications => changes)
    redirect_to home_path
  end
end
