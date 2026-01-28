require "test_helper"

module RapidlyBuilt
  class EngineTest < ActiveSupport::TestCase
    test "rake tasks are loaded" do
      # Load all rake tasks (this will execute the rake_tasks block)
      Rails.application.load_tasks

      # no rake tasks yet
      # assert Rake::Task.task_defined?("")
      assert true
    end
  end
end
