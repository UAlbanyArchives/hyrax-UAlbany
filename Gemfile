source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.5'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.3.6'
# Use Puma as the app server
gem 'puma', '~> 4.3.9'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
#gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# hyrax gems
gem 'hyrax', '2.9.0'
group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end
gem 'rsolr', '>= 1.0'
gem 'jquery-rails'
gem 'devise', '~> 4.7.1'
gem 'devise-guests', '~> 0.6'
group :development, :test do
  gem 'fcrepo_wrapper'
  gem 'rspec-rails'
end
#until hydra-derivatives bugfix is released (https://github.com/samvera/hydra-derivatives/pull/211)
gem 'hydra-derivatives', :git => 'https://github.com/gwiedeman/hydra-derivatives.git'
# to prevent browse-everything > 1 from requiring browse_everything_providers.yml and crashing (https://github.com/samvera/hyrax/issues/4140)
gem 'browse-everything', '< 1.0.0'
gem 'riiif', '~> 1.1'
# Sidekiq for background jobs
gem 'sidekiq', '~> 5.1.3'
# pdfjs for displaying PDF files in views
gem 'pdfjs_viewer-rails'
# To manage users in the db
gem 'hydra-role-management'

gem 'pg'
group :production do
    # for virus scanning
    #gem 'clamav'
end

gem 'blacklight', '~> 6.23.0'
gem 'hydra-head', '~> 11.0.1'

# these are manual updates for vulnerabilities
gem "bootstrap-sass", ">= 3.4.1"
gem "rack", ">= 2.0.6"
gem 'rubyzip','>= 2.0.0'
gem 'simple_form', '>= 5.0.0'
gem 'nokogiri', '>= 1.11.0'
gem 'oauth', '>= 0.5.5'
gem 'carrierwave', '>= 1.3.2'
