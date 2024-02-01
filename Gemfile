source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '= 6.1.7.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 5.6.8'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '>= 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# hyrax gems
gem 'hyrax', '4.0.0'
gem 'blacklight', '~> 7.33'
gem 'blacklight-gallery', '~> 4.4.0'
gem 'bootstrap', '~> 4.0'
gem 'jquery-rails'
gem 'tinymce-rails', '~> 5.10'
group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end
gem 'rsolr', '>= 1.0'
gem 'devise', '~> 4'
gem 'devise-guests', '~> 0.6'
group :development, :test do
  gem 'fcrepo_wrapper'
  gem 'rspec-rails'
end
gem 'json-canonicalization', '~> 0.4.0'

#gem 'browse-everything'
gem 'riiif'
# Sidekiq for background jobs
gem 'sidekiq', '~> 6.5.10'
# To manage users in the db
gem 'hydra-role-management'

gem 'pg', '1.2.3'
gem 'psych', '~> 3.3.4'

# shared header, footer, etc.
#gem 'grenander', git: 'https://github.com/UAlbanyArchives/grenander', branch: 'main'
gem 'grenander', path: '../grenander'

group :production do
    # for virus scanning
    #gem 'clamav'
end

# these are manual updates for vulnerabilities
gem 'openseadragon', '>= 0.2.0'
