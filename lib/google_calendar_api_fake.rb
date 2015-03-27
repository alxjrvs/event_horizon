class GoogleCalendarAPIFake
  @@events = []

  def initialize(calendar_id)
  end

  def events
    @@events.map { |event|
      CalendarEvent.new(event_json_data_format(event))
    }
  end

  def event_json
    @events
  end

  def self.set_event(event)
    @@events << event
  end

  def self.clear_events
    @@events = []
  end

  private

  def event_json_data_format(json)
    {
      start_time: parse_date_string(json, "start"),
      end_time: parse_date_string(json, "end"),
      summary: json["summary"],
      url: json["htmlLink"]
    }
  end

  def parse_date_string(json, key)
    return nil unless json[key]

    if json[key]["date"]
      Date.parse(json[key]["date"])
    elsif json[key]["dateTime"]
      DateTime.parse(json[key]["dateTime"])
    end
  end
end
