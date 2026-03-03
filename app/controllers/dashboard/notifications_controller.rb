# frozen_string_literal: true

class Dashboard::NotificationsController < Dashboard::BaseController
  include Pagy::Method

  PER_PAGE = 15

  def index
    @pagy, @notifications = pagy(:offset, current_user.notifications.recent, limit: PER_PAGE)
    render partial: "dashboard/notifications/page",
           locals: { notifications: @notifications, pagy: @pagy }
  end

  def mark_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read_at: Time.current) if notification.unread?
    render json: { ok: true }
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    render json: { unread_count: 0 }
  end
end
