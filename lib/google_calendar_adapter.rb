class GoogleCalendarAdapter
  attr_reader :calendar

  def initialize(calendar_id)
    @calendar = Rails.configuration.google_calendar.new(calendar_id)
  end

  def fetch_events(start_time = nil, end_time = nil)
    @calendar.fetch_events(start_time, end_time)
  end

  def calendar_id
    @calendar.calendar_id
  end
end
