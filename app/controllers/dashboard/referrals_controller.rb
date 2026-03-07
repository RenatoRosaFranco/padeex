# frozen_string_literal: true

class Dashboard::ReferralsController < Dashboard::BaseController
  def index
    @referrals = current_user.referrals.order(created_at: :desc)
  end
end
