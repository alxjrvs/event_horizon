FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    body "This is definitely a question."
    category "Other"
    user

    factory :code_syntax_question do
      category "Code syntax"
    end
  end
end
