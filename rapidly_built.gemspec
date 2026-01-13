require_relative "lib/rapidly_built/version"

Gem::Specification.new do |spec|
  spec.name        = "rapidly_built"
  spec.version     = RapidlyBuilt::VERSION
  spec.authors     = [ "dcunning" ]
  spec.email       = [ "31681+dcunning@users.noreply.github.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of RapidlyBuilt."
  spec.description = "TODO: Description of RapidlyBuilt."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # TODO: plugin applications without Rails (just mountable Rack applications)
  spec.add_dependency "rails", ">= 8.1.1"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.add_development_dependency "simplecov", "~> 0.22"
end
