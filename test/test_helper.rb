# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "simplecov"
SimpleCov.start do
  add_group "App", "app"
  add_group "Lib", "lib/rapidly_built"

  add_filter "/test/"
  add_filter "/lib/rapidly_built/version.rb" # loaded too early to track
  add_filter "/lib/tasks/rapidly_built_tasks.rake"

  track_files "{app,lib}/**/*.rb"
end

require_relative "../test/dummy/config/environment"
require "rails/test_help"

Dir.chdir("test") do
  Dir.glob("support/**/*.rb").sort.each { |f| require_relative f }
end

# Reset RapidlyBuilt configuration after each test to prevent state leakage
class ActiveSupport::TestCase
  teardown do
    RapidlyBuilt.reset!
  end
end
