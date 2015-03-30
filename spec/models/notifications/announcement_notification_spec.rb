require 'rails_helper'

describe Notifications::AnnouncementNotification do
  describe '#dispatch' do

    it 'sends a formated message to the flowdock wrapper' do
      flow_dock = double
      announcement = FactoryGirl.create(:announcement)

      expect(Notifications::FlowDock).to receive(:new).with(
        content:
        "@everyone, #{announcement.title}: #{announcement.description}",
        external_user_name: "Launch-Staff"
      ).and_return(flow_dock)
      expect(flow_dock).to receive(:push_to_chat)
      Notifications::AnnouncementNotification.new(announcement).dispatch
    end
  end
end
