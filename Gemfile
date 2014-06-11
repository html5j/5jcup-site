source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 3.2.16'
gem 'rails-i18n'

gem 'rmagick'

gem 'locomotive_cms', '~> 2.4.1', :require => 'locomotive/engine'

gem 'locomotive-heroku', '~> 0.1.0', :require => 'locomotive/heroku'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-hatena'
gem 'figaro'
gem 'haml-rails'

group :production, :staging do
  gem 'rails_12factor'
  gem 'thin'
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


group :development, :test do
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rspec-rails'
  gem 'spork'
  gem 'factory_girl_rails'
  gem 'fabrication'
end

group :test do
  gem 'database_cleaner'
  gem 'rb-fsevent', '0.9.4', :require => false
  gem 'rspec-nc'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'webrat'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'compass-rails',  '~> 1.1.3'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end


group :development do
    gem "pry-rails"
    gem "pry-debugger"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
