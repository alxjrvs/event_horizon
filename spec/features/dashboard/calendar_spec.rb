require "rails_helper"

feature "view dashboard calendar" do
  let(:user) do
    FactoryGirl.create(:user_with_calendar,
      calendar_args: { cid: ENV["DEFAULT_GOOGLE_CALENDAR_ID"] }
    )
  end
  let(:event1) do {
      "htmlLink"=>"www.google.com/calendar", "summary"=>"Community: Boston MySQL Monthly Meetup",
      "start"=>{"dateTime"=>"2015-02-09T19:00:00-05:00"}, "end"=>{"dateTime"=>"2015-02-09T20:00:00-05:00"}
    }
  end
  let(:event2) do {
      "htmlLink"=>"www.google.com/calendar", "summary"=>"Past Event",
      "start"=>{"dateTime"=>"2015-02-09T09:00:00-05:00"}, "end"=>{"dateTime"=>"2015-02-09T10:00:00-05:00"}
    }
  end

  before(:each) do
    Redis.current.flushdb
  end

  after(:each) do
    Redis.current.flushdb
    GoogleCalendarAPIFake.clear_events
  end

  context "with events in the calendar" do
    before(:each) do
      GoogleCalendarAPIFake.set_event(event1)
      GoogleCalendarAPIFake.set_event(event2)
    end

    scenario "user sees event information" do
      sign_in_as(user)
      visit dashboard_path
      expect(page).to have_content("Monday, February 9 at 7:00 PM")
      expect(page).to have_link("Community: Boston MySQL Monthly Meetup")
      expect(page.all("table.calendar tr a").first[:href]).
        to include 'www.google.com/calendar'
    end

    scenario %"events that have already started have a class of '.past-event'" do
      sign_in_as(user)
      visit dashboard_path
      expect(page).to have_css("table.calendar tr.past-event")
      within(first("tr.past-event")) do
        expect(page).to have_content("Past Event")
      end
    end
  end

  context "with no events in the calendar" do
    scenario "'no upcoming events' is displayed" do
      sign_in_as(user)
      visit dashboard_path
      expect(page).to have_content("No upcoming events")
    end
  end
end
