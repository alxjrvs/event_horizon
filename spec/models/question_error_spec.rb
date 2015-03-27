require 'rails_helper'

describe QuestionError do
  describe '#nice_message' do
    it 'returns a nice message' do
      errors = { title: ["some error"], body: ["error1", "error2"] }
      question_error = QuestionError.new(errors)
      expect(question_error.nice_message).to eq "Failed to save question. Title: some error, Body: error1, error2."
    end
  end
end
