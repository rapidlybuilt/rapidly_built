require "zeitwerk"
require "rapid_ui"

module RapidlyBuilt
  class Error < StandardError; end

  def self.loader
    @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
      loader.ignore("#{__dir__}/rapidly_built/engine.rb")
      loader.ignore("#{__dir__}/rapidly_built/cli/*.rb")
      loader.ignore("#{__dir__}/rapidly_built/cli.rb")
      loader.setup
    end
  end

  loader

  # Reset the configuration to a clean state
  # Useful for testing to prevent state from leaking between tests
  #
  # @return [Config] The reset configuration object
  def self.reset!
    @config = Config.new
  end
end

require "rapidly_built/engine" if defined?(Rails::Engine)
