source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 5.0.0", ">= 5.0.0.1"
# Use postgresql
gem "pg", "~> 0.19"
# Use Puma as the app server
gem "puma", "~> 3.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "pry-rails"

  # Factories
  gem "factory_girl_rails"
  gem "faker"

  # Testing
  gem "rspec-rails"
  gem "rspec-sidekiq", "~> 2.2"
  gem "rails-controller-testing"
  gem "guard-rspec", require: false
end

group :development do
  # Console on exception pages
  gem "web-console"
  gem "listen", "~> 3.0.5"

  # Preloader
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring-commands-rspec"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Linting
gem "rubocop"
gem "rubocop-rspec"

# Images
gem "carrierwave", ">= 1.0.0.beta", "< 2.0"
gem "mini_magick", "~> 4.5"

# Pagination
gem "kaminari", "~> 0.17"

# Authentication
gem "argon2", "~> 1.1"

# Permissions
gem "pundit", "~> 1.1"

# Background jobs
gem "sidekiq", "~> 4.2"

gem "knock", "~> 1.5"

# Allowing CORS for API
gem "rack-cors", "~> 0.4", require: "rack/cors"

# For controllers
gem "decent_exposure", "~>3.0"
