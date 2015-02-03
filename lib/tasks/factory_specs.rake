namespace :spec do
  desc "Run factory specs"
  RSpec::Core::RakeTask.new(:factories) do |t|
    t.pattern = "./spec/support/factories_spec.rb"
  end
end
