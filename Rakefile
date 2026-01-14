require "bundler/setup"

require "bundler/gem_tasks"

require "rubocop/rake_task"

RuboCop::RakeTask.new

namespace :test do
  desc "Run tests in the dummy Rails app"
  task :default do
    system("bin/test")
  end

  desc "Run all tests including system tests"
  task :all do
    files = Dir.glob("test/**/*_test.rb")
    system("bin/test", *files)
  end

  desc "Run only system tests"
  task :system do
    system("bin/test test/system")
  end
end

task test: "test:default"

task default: %i[rubocop test:all]
