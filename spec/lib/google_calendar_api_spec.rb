require "rails_helper"

describe GoogleCalendarAPI, :vcr do
  describe "#fetch_events" do
    let(:calendar) do
      GoogleCalendarAPI.new(ENV["DEFAULT_GOOGLE_CALENDAR_ID"])
    end

    it "should return a array of event data" do
      events = calendar.events
      expect(events).to be_an Array
      expect(events.first).to be_a CalendarEvent
    end

    it "should scope events to a date range" do
      start_time = DateTime.now.beginning_of_day
      end_time = DateTime.now.end_of_day + 1.day
      events = calendar.events
      event_time = events.first.start_time

      expect(event_time).to be_between(start_time, end_time)
    end
  end
end
