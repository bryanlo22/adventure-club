class UserController < ApplicationController
  load_and_authorize_resource :user

  def index
    @users = User.all.sort_by{|user| user.name}
  end

  def new
    @user = User.new
    @path = create_user_path
    render 'form'
  end

  def edit
    @user = User.where(:id => params[:id]).first
    @path = update_user_path(params[:id])
    render 'form'
  end

  def create
    user = User.new
    handle(user)
  end

  def update
    user = User.where(:id => params[:id]).first
    handle(user)
  end

  def handle(user)
    user.email = params[:email]
    user.name = params[:name]
    user.image = params[:image]
    user.roles = params[:roles] || []
    changes = user.changes
    user.save!
    Audit.create!(:user => current_user.id.to_s, :type => 'User', :modifications => changes)
    redirect_to users_path
  end

end
