FactoryGirl.define do
  factory :source_file do
    submission
    filename "foo.rb"
    body "2 + 2 == 5\n"
  end
end
