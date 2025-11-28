source 'https://rubygems.org'

ruby '3.0.2'

gem 'propshaft'
gem 'rails', '~> 8.1.0'

# Desenvolvimento e Teste com SQLite
group :development, :test do
  gem 'sqlite3', '>= 2.1'
end

# Produção com Postgres (Heroku)
group :production do
  gem 'pg'
end

gem 'importmap-rails'
gem 'jbuilder'
gem 'puma', '>= 5.0'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'devise', github: 'heartcombo/devise', branch: 'main'

gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

gem 'bootsnap', require: false
gem 'thruster', require: false

gem 'active_storage_validations'
gem 'image_processing', '~> 1.2'
gem 'rails_autolink'

gem 'tailwindcss-rails', '~> 4.4'
gem 'wicked_pdf'
# gem 'wkhtmltopdf-binary'
gem 'deep_cloneable'

# gemas que tão nos slides de esi e parecem legais pra testar metrica
gem 'railroady'
# gem 'metric_fu'
gem 'flog'
# gem 'saikuro'

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'factory_bot_rails'
  gem 'rubocop-rails-omakase', require: false
end

group :development do
  gem 'web-console'
end

gem 'devise-i18n'
gem 'rails-i18n'
gem 'rubyzip'

group :test do
  gem 'capybara'
  gem 'cucumber'
  gem 'database_cleaner-active_record'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.0'
end
