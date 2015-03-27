class GoogleCalendarAdapter
  attr_reader :calendar

  def initialize(calendar_id)
    @calendar = Rails.configuration.google_calendar.new(calendar_id)
  end

  def events
    @calendar.events
  end

  def event_json
    @calendar.event_json
  end

  def calendar_id
    @calendar.calendar_id
  end
end
