class AuditController < ApplicationController
  load_and_authorize_resource :class => :audit

  def index
    audits = Audit.collection.aggregate([
      {
        :$project => {
          :_id => '$_id',
          :created_at => '$created_at',
          :user_id => '$user',
          :type => '$type',
          :modifications => '$modifications'
        }
      }
    ])

    @audits = []
    audits.each do |audit|
      @audits << audit
    end

    users = User.get_users

    @audits.each do |audit|
      id = audit['user_id']
      audit['name'] = users[id][:name]
      audit['image'] = users[id][:image]
    end
  end

end