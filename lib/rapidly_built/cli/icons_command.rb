module RapidlyBuilt
  module CLI
    class IconsCommand < Thor
      no_commands do
        def exit_on_failure?
          true
        end
      end

      desc "import NAME", "Import a Lucide icon to your project"
      def import(name)
        require "rapid_ui/commands/icons"
        RapidUI::Commands::Icons.new(base_dir: Dir.pwd).run([ "import", name ])
      end

      desc "upgrade VERSION", "Upgrade all imported icons to a new version"
      def upgrade(version)
        require "rapid_ui/commands/icons"
        RapidUI::Commands::Icons.new(base_dir: Dir.pwd).run([ "upgrade", version ])
      end
    end
  end
end
