require_relative "lib/rapidly_built/version"

Gem::Specification.new do |spec|
  spec.name        = "rapidly_built"
  spec.version     = RapidlyBuilt::VERSION
  spec.authors     = [ "Dan Cunning" ]
  spec.email       = [ "dan@rapidlybuilt.com" ]
  spec.homepage    = "https://rapidlybuilt.com/tools/rapidly-built"
  spec.summary     = "The foundation for building RapidlyBuilt tools."
  spec.description = "The foundation for building RapidlyBuilt tools."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rapidlybuilt/rapidly_built"
  # spec.metadata["changelog_uri"] = "https://github.com/rapidlybuilt/rapidly_built/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,bin}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.bindir = "bin"

  # TODO: don't require Rails (just mountable Rack applications)
  spec.add_dependency "rails", ">= 8.1.1"
  spec.add_dependency "zeitwerk", "~> 2.7"
  spec.add_dependency "rapid_ui", "= 0.2.3"
  spec.add_dependency "thor", "~> 1"
end
