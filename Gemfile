source "https://rubygems.org"

# Specify your gem's dependencies in rapidly_built.gemspec.
gemspec

gem "puma"

# Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
gem "rubocop-rails-omakase", require: false

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

# bundle config https://rubygems.pkg.github.com/dcunning USERNAME:TOKEN
source "https://rubygems.pkg.github.com/dcunning" do
  gem "rapid_ui"
end
# gem "rapid_ui", path: "../rapid_ui"


# Testing gems
group :test do
  gem "capybara", "~> 3.39"
  gem "cuprite", "~> 0.15"
  gem "simplecov", "~> 0.22"
  gem "spy", "~> 1.0"
end
