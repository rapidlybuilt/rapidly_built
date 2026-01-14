namespace :rapid do
  namespace :stylesheets do
    task :update do
      require "rapid_ui"

      source = RapidUI.root.join("app/assets/builds/rapid_ui/application.css")

      destination = "vendor/stylesheets/rapid_ui"
      FileUtils.mkdir_p(destination)
      FileUtils.cp_r(source, destination)

      # Prepend version comment to the copied file
      dest_file = File.join(destination, File.basename(source))
      content = File.read(dest_file)
      File.write(dest_file, "/* RapidUI v#{RapidUI::VERSION} | MIT License | https://rapidlybuilt.com/tools/ui/ */\n#{content}")

      puts "Updated #{destination} to RapidUI v#{RapidUI::VERSION}"
    end
  end
end
