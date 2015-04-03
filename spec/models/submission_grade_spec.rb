require 'rails_helper'

RSpec.describe SubmissionGrade, :type => :model do
  it { should belong_to :submission }

  it { should have_valid(:submission).when(Submission.new) }
  it { should_not have_valid(:submission).when(nil) }

  it do
    should have_valid(:score).when(*described_class.scores.keys)
  end

  it { should_not have_valid(:score).when(nil) }
end
