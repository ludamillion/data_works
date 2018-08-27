require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_support/all'
require 'active_support/testing/time_helpers'
require 'factory_bot'
require 'database_cleaner'
require 'active_hash'
require 'sqlite3'
require_relative 'factories/factories'

Bundler.require(:default, :development)

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

end

