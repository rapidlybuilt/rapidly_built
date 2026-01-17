require "test_helper"

module RapidlyBuilt
  module Rails
    class RailtieTest < ActiveSupport::TestCase
      test "rake tasks are loaded" do
        # Load all rake tasks (this will execute the rake_tasks block)
        ::Rails.application.load_tasks

        # Verify that the rapid:stylesheets:update rake task is defined
        assert Rake::Task.task_defined?("rapid:stylesheets:update")
      end
    end
  end
end
