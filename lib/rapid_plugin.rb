require "zeitwerk"

module RapidPlugin
  def self.loader
    @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
      loader.ignore("#{__dir__}/rapid_plugin/railtie.rb")
      loader.setup
    end
  end

  loader
end

require "rapid_plugin/railtie"
