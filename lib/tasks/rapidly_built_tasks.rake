namespace :rapid do
  namespace :tailwind do
    task :symlink => :gitignore do
      # HACK: I want a better way to do share RapidUI's tailwind styles with applications.
      require "rapid_ui"

      source = RapidUI.root.join("app/assets/stylesheets/rapid_ui")

      destination = "vendor/stylesheets"
      FileUtils.mkdir_p(destination)

      symlink_path = File.join(destination, File.basename(source))
      FileUtils.rm_f(symlink_path)
      FileUtils.ln_s(source, symlink_path)
      puts "Linked #{symlink_path} -> #{source} (RapidUI v#{RapidUI::VERSION})"
    end

    task :gitignore do
      gitignore_path = ".gitignore"
      gitignore_entry = "/vendor/stylesheets/rapid_ui"

      if File.exist?(gitignore_path)
        content = File.read(gitignore_path)
        unless content.include?(gitignore_entry)
          File.open(gitignore_path, "a") { |f| f.puts gitignore_entry }
          puts "Added #{gitignore_entry} to .gitignore"
        end
      end
    end
  end
end
