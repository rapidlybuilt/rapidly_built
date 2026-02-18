module ConsoleSupport
  # Console used by Setup when params[:console_id] is :application (default).
  # Configure per test via ApplicationConsole.test_config = ->(console) { ... }.
  class TestConsole < RapidlyBuilt::Console::Base
    class << self
      attr_accessor :test_config
    end

    def initialize(**kwargs)
      super(**kwargs)
      self.class.test_config&.call(self)
    end
  end

  def stub_console(console_id, klass)
    Spy.on(RapidlyBuilt::UsesConsole, :find_console_class).and_return do |id|
      id.to_s == console_id.to_s ? klass : raise("Unexpected console ID: #{id}")
    end
  end

  def unstub_console
    Spy.off(RapidlyBuilt::UsesConsole, :find_console_class)
  end

  def stub_test_console(console_id = :application, &test_config)
    TestConsole.test_config = test_config
    stub_console(console_id, TestConsole)
  end

  def unstub_test_console
    TestConsole.test_config = nil
    unstub_console
  end
end
