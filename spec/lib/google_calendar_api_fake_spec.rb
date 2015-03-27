require 'rails_helper'

describe GoogleCalendarAPIFake do
  let(:adapter) { GoogleCalendarAPIFake.new("") }
  let(:event) { { "kind" => "calendar#event" } }

  before(:each) do
    described_class.clear_events
  end

  describe "#fetch_events" do
    it "returns a Hash" do
      expect(adapter.fetch_events).to be_a Array
    end
  end

  describe '.set_event' do
    it 'stores the event in a local array of events' do
      described_class.set_event(event)
      expect(adapter.fetch_events).to eq([event])
    end
  end

  describe '.clear_events' do
    it 'clears all events' do
      described_class.set_event(event)
      described_class.clear_events
      expect(adapter.fetch_events).to eq []
    end
  end
end
