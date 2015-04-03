require "rails_helper"

describe Calendar do
  let(:event) do {
    "summary" => "some summary", "url" => "some link",
    "start_time" => Date.today.to_s, "end_time" => Date.today.to_s}
  end

  before(:each) do
    GoogleCalendarAPIFake.set_event(event)
  end

  after(:each) do
    GoogleCalendarAPIFake.clear_events
  end

  it { should have_many(:teams) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cid) }


  describe "events" do
    context 'when events are stored in Redis' do
      it 'returns an array of CalendarEvents' do
        ce1 = double(start_time: Time.now, end_time: Time.now + 1.hour)
        redis_db = double
        allow(Redis).to receive(:current).and_return(redis_db)
        allow(redis_db).to receive(:get).and_return(
          [
            {
              "summary" => "some summary",
              "url" => "some link",
              "start_time" => Date.today,
              "end_time" => Date.today
            }.to_json
          ].to_json
        )
        allow(CalendarEvent).to receive(:new).with({
          "summary" => "some summary",
          "url" => "some link",
          "end_time" => Date.today.to_s,
          "start_time" => Date.today.to_s,
        }).and_return(ce1)

        expect(Calendar.new(cid: 'cid', name: 'name').events).to match_array([ce1])
      end
    end
  end

  describe "cid validation" do
    subject { FactoryGirl.create(:calendar) }
    it { should validate_uniqueness_of(:cid) }
  end

  context "storing and retrieving with redis" do
    let(:redis) { Redis.current }
    let(:calendar) do
      FactoryGirl.create(:calendar, cid: ENV["DEFAULT_GOOGLE_CALENDAR_ID"])
    end

    around(:each) do
      redis.flushdb
    end

    it "stores events in redis after a call to events" do
      expect(redis.keys).to_not include(calendar.cid)
      calendar.events_json
      expect(redis.keys).to include(calendar.cid)
    end

    it "retrieves events from Redis if they exist" do
      fake_event_data = ["FAKE EVENT DATA"].to_json
      redis.set(calendar.cid, fake_event_data)
      expect(calendar.events_json).to eq(JSON.parse(fake_event_data))
    end
  end
end
