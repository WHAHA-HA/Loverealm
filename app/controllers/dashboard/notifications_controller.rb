class Dashboard::NotificationsController < ApplicationController
  def index
    @activities = Notification.for_user(current_user)
                              .includes([:recipient, :owner, :trackable])
                              .page(params[:page]).per(20)
    @grouped_activities = @activities.group_by do |activity|
      activity.created_at.to_date
    end
    current_user.update_column :notifications_checked_at, Time.now
  end
end
