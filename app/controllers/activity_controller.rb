class ActivityController < ApplicationController
  load_and_authorize_resource :activity

  def activity_params
    params.require(:activity).permit(:event, :activity, :points, :description, :user)
  end

  def index
    activities = Activity.collection.aggregate([
      {
        :$sort => {
          :date => 1
        }
      },
      {
        :$project => {
          :_id => '$_id',
          :event => '$event',
          :date => '$date',
          :user_id => '$user',
          :points => '$points',
          :description => '$description'
        }
      }
    ])

    @activities = []
    activities.each do |activity|
      @activities << activity
    end

    user_names = User.get_user_names

    @activities.each do |activity|
      id = activity['user_id']
      activity['user'] = user_names[id]
    end
  end

  def new
    @activity = Activity.new
    @users = User.all.sort_by{|user| user.name}
    @path = create_activity_path
    render 'form'
  end

  def edit
    @activity = Activity.where(:id => params[:id]).first
    @date = @activity.date.strftime('%B %d, %Y')
    @users = User.all.sort_by{|user| user.name}
    @path = update_activity_path
    render 'form'
  end

  def create
    activity = Activity.new
    handle(activity)
  end

  def update
    activity = Activity.where(:id => params[:id]).first
    handle(activity)
  end

  def handle(activity)
    activity.event = params[:event]
    activity.date = params[:activity]['date'].to_date
    activity.points = params[:points]
    activity.description = params[:description]
    activity.user = params[:user]['id']
    changes = activity.changes
    activity.save!
    Audit.create!(:user => current_user.id.to_s, :type => 'activity', :modifications => changes)
    redirect_to activities_path
  end

end