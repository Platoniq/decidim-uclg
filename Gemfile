# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.26.4"

gem "decidim", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-decidim_awesome", "~> 0.8"
gem "decidim-direct_verifications", "~> 1.1"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "release/0.26-stable"

gem "bootsnap", "~> 1.4"
gem "health_check"
gem "sentry-rails"
gem "sentry-ruby"
gem "sidekiq", "~> 6.0"
gem "sidekiq-cron"

# bug in version 1.9
gem "i18n", "~> 1.8.1"

gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"

gem "faker", "~> 2.14"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "rubocop-faker"

  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  gem "capistrano", "~> 3.14"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
  gem "capistrano-sidekiq"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "figaro", "~> 1.2"
  gem "fog-aws" # to remove once image migration is complete
end
