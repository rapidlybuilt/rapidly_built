# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "simplecov"
SimpleCov.start

require_relative "../test/dummy/config/environment"
require "rails/test_help"
