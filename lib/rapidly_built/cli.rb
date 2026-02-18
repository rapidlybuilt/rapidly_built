require_relative "cli/icons_command"
require_relative "cli/tailwind_command"

module RapidlyBuilt
  module CLI
    class Container < Thor
      def self.exit_on_failure?
        true
      end

      no_commands do
        def exit_on_failure?
          true
        end
      end

      desc "icons SUBCOMMAND ARGS", "Import or upgrade Lucide icons"
      subcommand "icons", CLI::IconsCommand

      desc "tailwind SUBCOMMAND ARGS", "Build, watch, or clean Tailwind CSS"
      subcommand "tailwind", CLI::TailwindCommand
    end

    class Config
      # Tailwind CSS build configs passed to RapidUI::Commands::TailwindCSS.
      # Hash of target => options, e.g. { tools: { input:, output:, build_dir:, import: [] }, nil => { input:, output:, build_dir: } }
      attr_accessor :tailwind

      def initialize
        @tailwind = {}
      end
    end

    class << self
      def start(*args, **kwargs)
        CLI::Container.start(*args, **kwargs)
      end

      # Get or configure the RapidlyBuilt configuration
      #
      # @yield [Config] The configuration object
      # @return [Config] The configuration object
      def config
        @config ||= Config.new
        yield @config if block_given?
        @config
      end
    end
  end
end
