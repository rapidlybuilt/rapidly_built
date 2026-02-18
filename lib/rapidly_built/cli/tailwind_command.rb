module RapidlyBuilt
  module CLI
    class TailwindCommand < Thor
      no_commands do
        def exit_on_failure?
          true
        end
      end

      desc "build [TARGET]", "Build Tailwind CSS once (TARGET or --target, e.g. main or tools)"
      option :target, type: :string, desc: "Target config (e.g. tools)"
      def build(target = nil)
        run_tailwind("build", target)
      end

      desc "watch [TARGET]", "Build Tailwind CSS and watch for changes"
      option :target, type: :string, desc: "Target config (e.g. tools)"
      def watch(target = nil)
        run_tailwind("watch", target)
      end

      desc "clean [TARGET]", "Remove the build artifact"
      option :target, type: :string, desc: "Target config (e.g. tools)"
      def clean(target = nil)
        run_tailwind("clean", target)
      end

      private

      def run_tailwind(command, target_arg = nil)
        require "rapid_ui/commands/tailwind_css"
        configs = RapidlyBuilt::CLI.config.tailwind

        if configs.nil? || configs.empty?
          $stderr.puts "❌ No tailwind config. Set RapidlyBuilt::CLI.config.tailwind before starting this command."
          exit 1
        elsif !configs.is_a?(Hash)
          $stderr.puts "❌ Tailwind config must be a Hash."
          exit 1
        end

        target = target_arg || options[:target]
        args = [ command ]
        args << "--target" << target if target
        RapidUI::Commands::TailwindCSS.new(configs).run(args)
      end
    end
  end
end
