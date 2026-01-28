require "zeitwerk"
require "rapid_ui"

module RapidlyBuilt
  class Error < StandardError; end
  class ToolkitNotFoundError < Error; end
  class ToolNotFoundError < Error; end
  class ToolNotUniqueError < Error; end

  def self.loader
    @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
      loader.ignore("#{__dir__}/rapidly_built/engine.rb")
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

  # Register a tool class with the default toolkit
  #
  # @param tool_class [Class] The tool class to register
  # @return [Toolkit] The default toolkit instance
  # @example
  #   RapidlyBuilt.register_tool! MyGem::Tool
  def self.register_tool!(tool_class)
    config.default_toolkit.add_tool(tool_class)
  end
end

require "rapidly_built/engine" if defined?(Rails::Engine)
