require 'rails_helper'

describe QuestionDecorator do
  include Draper::ViewHelpers

  describe '#can_accept?' do
    let(:author) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question, user: author).decorate }

    before do
      allow(helpers).to receive(:current_user).and_return(user)
    end

    context 'no current_user' do
      let(:user) { nil }

      it 'should return false' do
        expect(question.can_accept?).to eq false
      end
    end

    context 'user is admin' do
      let(:user) { create(:admin) }

      it 'should return true' do
        expect(question.can_accept?).to eq true
      end
    end

    context 'user is not admin' do
      context 'user owns question' do
        let(:user) { author }

        it 'should return true' do
          expect(question.can_accept?).to eq true
        end
      end

      context 'user does not own question' do
        let(:user) { create(:user) }

        it 'should return false' do
          expect(question.can_accept?).to eq false
        end
      end
    end
  end

  describe '#can_unaccept?' do
    let(:author) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question, user: author).decorate }
    let(:user) { create(:user) }

    before(:each) do
      answer = FactoryGirl.create(:answer, question: question)
      question.update_attributes(accepted_answer: answer)
      allow(helpers).to receive(:current_user).and_return(user)
    end

    context 'answer is accepted' do
      context 'user is admin' do
        let(:user) { create(:admin) }

        it 'should return true' do
          expect(question.can_unaccept?).to eq true
        end
      end

      context 'user owns question' do
        let(:user) { author }
        it 'should return true' do
          expect(question.can_unaccept?).to eq true
        end
      end

      context 'user does not own question' do
        it 'should return false' do
          expect(question.can_unaccept?).to eq false
        end
      end
    end

    context 'answer is not accepted' do
      it 'should return false' do
        answer = stub(accepted?: false)
        expect(question.can_unaccept?).to eq false
      end
    end
  end

  describe '#display_total_votes' do
    let(:question) { FactoryGirl.create(:question).decorate }

    it 'should display total votes' do
      result = question.display_total_votes
      markup = Capybara.string(result)
      expect(markup.text).to eql "0"
    end
  end

  describe '#upvote' do
    let(:question) { FactoryGirl.create(:question).decorate }

    context 'authorized user' do
      let(:user) { create(:user) }

      before do
        allow(helpers).to receive(:current_user).and_return(user)
      end

      context 'user has voted' do
        it 'displays link with arrow up' do
          FactoryGirl.create(:vote, score: 1, user: user, votable_id: question.id, votable_type: "Question")

          result = question.upvote
          markup = Capybara.string(result)
          expect(markup).to have_selector('i.upvote')
          expect(markup).to have_selector('i.upvote.cast')
        end
      end

      context 'user has not voted' do
        it 'displays link with arrow up' do
          result = question.upvote
          markup = Capybara.string(result)
          expect(markup).to have_selector('i.upvote')
          expect(markup).to_not have_selector('i.upvote.cast')
        end
      end
    end

    context 'unauthorized user' do
      it 'displays empty <i> tag' do
        result = question.upvote
        markup = Capybara.string(result)
        expect(markup).to have_selector('i.mam')
      end
    end
  end

  describe '#downvote' do
    let(:question) { FactoryGirl.create(:question).decorate }
    let(:user) { create(:user) }

    context 'authorized user' do
      before do
        allow(helpers).to receive(:current_user).and_return(user)
      end

      context 'user has downvoted' do
        it 'displays link with arrow down' do
          FactoryGirl.create(:vote, score: -1, user: user, votable_id: question.id, votable_type: "Question")

          result = question.downvote
          markup = Capybara.string(result)
          expect(markup).to have_selector('i.downvote')
          expect(markup).to have_selector('i.downvote.cast')
        end
      end

      context 'user has not voted' do
        it 'displays link with arrow down' do
          result = question.downvote
          markup = Capybara.string(result)
          expect(markup).to have_selector('i.downvote')
          expect(markup).to_not have_selector('i.downvote.cast')
        end
      end
    end

    context 'unauthorized user' do
      it 'displays empty <i> tag' do
        result = question.downvote
        markup = Capybara.string(result)
        expect(markup).to have_selector('i.mam')
      end
    end
  end
end
