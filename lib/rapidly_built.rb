require "zeitwerk"

module RapidlyBuilt
  class Error < StandardError; end
  class ApplicationNotFoundError < Error; end

  def self.loader
    @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
      loader.ignore("#{__dir__}/rapidly_built/railtie.rb")
      loader.setup
    end
  end

  loader

  # Get or configure the RapidlyBuilt configuration
  #
  # @yield [Config] The configuration object
  # @return [Config] The configuration object
  def self.config
    @config ||= Config.new
    yield @config if block_given?
    @config
  end

  # Reset the configuration to a clean state
  # Useful for testing to prevent state from leaking between tests
  #
  # @return [Config] The reset configuration object
  def self.reset!
    @config = Config.new
  end

  # Register a plugin class with the default application
  #
  # @param plugin_class [Class] The plugin class to register
  # @return [Application] The default application instance
  # @example
  #   RapidlyBuilt.register! MyGem::Plugin
  def self.register!(plugin_class)
    config.default_application.add_plugin(plugin_class)
  end
end

require "rapidly_built/rails/railtie" if defined?(Rails::Railtie)
