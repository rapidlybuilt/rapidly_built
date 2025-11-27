# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "simplecov"
SimpleCov.start do
  add_filter "/test/"
  add_filter "/lib/rapid_plugin/version.rb" # loaded too early to track
  track_files "lib/**/*.rb"
end

require_relative "../test/dummy/config/environment"
require "rails/test_help"

# Reset RapidPlugin configuration after each test to prevent state leakage
class ActiveSupport::TestCase
  teardown do
    RapidPlugin.reset!
  end
end
