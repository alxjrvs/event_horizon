class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @latest_announcements = current_user.latest_announcements(5)
    @upcoming_noncore_assignments = current_user.non_core_assignments
    @upcoming_core_assignments = current_user.core_assignments
    @calendar_events = Calendar.events(current_user.calendars)
    @teams = current_user.teams
    @feed_items = Feedster::DecoratedCollection.new(
      current_user.received_feed_items.order('created_at DESC').limit(25)).decorate
  end
end
