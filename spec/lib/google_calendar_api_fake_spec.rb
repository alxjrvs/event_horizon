require 'rails_helper'

describe GoogleCalendarAPIFake do
  let(:adapter) { GoogleCalendarAPIFake.new("") }
  let(:event) { { "kind" => "calendar#event", "summary" => "an event" } }

  before(:each) do
    described_class.clear_events
  end

  describe '.set_event' do
    it 'stores the event in a local array of events' do
      described_class.set_event(event)
      expect(adapter.events.first.summary).to eq("an event")
    end
  end

  describe '.clear_events' do
    it 'clears all events' do
      described_class.set_event(event)
      described_class.clear_events
      expect(adapter.events).to eq []
    end
  end
end
