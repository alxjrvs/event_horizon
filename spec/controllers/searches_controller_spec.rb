require 'rails_helper'

describe SearchesController do
  describe '#index' do
    it 'sets the expect instance variables' do
      search_result = double(:search_result)
      lessons = double(:lessons)
      questions = double(:questions)
      results = double(:results)

      expect(SearchResult).to receive(:new).with('active record', 'challenge', anything).and_return(search_result)

      allow(search_result).to receive(:type).and_return('challenge')
      allow(search_result).to receive(:lessons).and_return(lessons)
      allow(search_result).to receive(:questions).and_return(questions)
      allow(search_result).to receive(:total).and_return(results)

      get :index, query: 'active record', type: 'challenge'

      expect(assigns(:active_type)).to eq 'challenge'
      expect(assigns(:lessons)).to eq lessons
      expect(assigns(:questions)).to eq questions
      expect(assigns(:results)).to eq results
    end
  end
end
