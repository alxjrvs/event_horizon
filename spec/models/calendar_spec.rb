require "rails_helper"

describe Calendar do
  it { should have_many(:teams) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cid) }

  describe "events" do
    it 'returns an array of CalendarEvents' do
      ce1 = stub(start_time: Time.now, end_time: Time.now + 1.hour)
      redis_db = stub
      Redis.stubs(:current).returns(redis_db)
      redis_db.stubs(:get).returns(
        [
          {
            "summary" => "some summary",
            "htmlLink" => "some link",
            "start" => { "date" => Date.today },
            "end" => { "date" => Date.today }
          }
        ].to_json
      )
      CalendarEvent.stubs(:new).with(
        url: "some link",
        summary: "some summary",
        end_time: Date.today,
        start_time: Date.today,
      ).returns(ce1)

      expect(Calendar.new(cid: 'cid', name: 'name').events).to match_array([ce1])
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
