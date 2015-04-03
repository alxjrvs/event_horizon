require 'rails_helper'

describe CalendarEvent do
  describe '#inititialize' do
    it 'sets initial data' do
      data = {
        "end_time" => 'end_time',
        "start_time" => 'start_time',
        "summary" => "some summary",
        "url" => "some link",
      }
      event = CalendarEvent.new(data)

      expect(event.end_time).to eq 'end_time'
      expect(event.start_time).to eq 'start_time'
      expect(event.summary).to eq 'some summary'
      expect(event.url).to eq 'some link'
    end
  end
end
