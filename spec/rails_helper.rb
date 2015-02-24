ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "sidekiq/testing"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/shared/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.before :each do
    OmniAuth.config.test_mode = true
    OmniAuth.config.logger = Logger.new("/dev/null")

    Sidekiq::Worker.clear_all
    Sidekiq::Testing.fake!

    ActionMailer::Base.deliveries.clear
  end

  RSpec.configure do |config|
    config.fuubar_progress_bar_options = { :format => 'Horizon: <%B> %p%% %a' }
  end

  config.include ApplicationHelper
  config.include AuthenticationHelper
  config.include ArchiveHelper
end
