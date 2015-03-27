class GoogleCalendarAPIFake
  @@events = []

  def initialize(calendar_id)
  end

  def fetch_events(start_time = nil, end_time = nil)
    @@events
  end

  def self.set_event(event)
    @@events << event
  end

  def self.clear_events
    @@events = []
  end
end
