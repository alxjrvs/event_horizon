FactoryGirl.define do
  factory :lesson do
    type "article"
    sequence(:title) { |n| "Article #{n}" }
    sequence(:slug) { |n| "article-#{n}" }
    description "Describes the article."
    body "# Article Foo\n\nThis is an article."
    visibility "public"

    factory :article do
      type "article"
    end

    factory :challenge do
      type "challenge"

      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/one_file.tar.gz"))
      end
    end
  end
end
