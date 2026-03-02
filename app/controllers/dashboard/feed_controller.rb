# frozen_string_literal: true

class Dashboard::FeedController < Dashboard::BaseController
  before_action :require_feed_flag

  def index
    @stories     = Feed::StoryService.for_user(current_user)
    @posts       = Feed::PostService.for_user(current_user)
    @suggestions = Feed::SuggestionService.for_user(current_user)
  end

  private

  def require_feed_flag
    redirect_to dashboard_path unless FeatureFlags.enabled?(:feed)
  end
end
