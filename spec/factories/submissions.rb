FactoryGirl.define do
  factory :submission do
    association :lesson, factory: :challenge
    user
    public false

    archive do
      Rack::Test::UploadedFile.new(Rails.root.join("spec/data/one_file.tar.gz"))
    end

    factory :submission_with_two_file_archive do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/two_files.tar.gz"))
      end
    end

    factory :submission_with_file do
      after(:create) do |submission|
        FactoryGirl.create(:source_file, submission: submission)
      end
    end

    factory :submission_with_nested_files do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/nested_files.tar.gz"))
      end
    end

    factory :submission_with_ignored_files do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/ignored_files.tar.gz"))
      end
    end

    factory :submission_with_large_file do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/large_file.tar.gz"))
      end
    end

    factory :submission_with_binary_file do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/binary_file.tar.gz"))
      end
    end

    factory :submission_with_gitignore do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/has_gitignore.tar.gz"))
      end
    end
  end
end
