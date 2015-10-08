ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'devise'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.include Devise::TestHelpers, type: :controller # sign_in, sign_out methods in controller specs
  config.include FactoryGirl::Syntax::Methods # create, build, etc. methods without FactoryGirl prefix
  config.include Omniauth::Mock
  config.include Api::V1
  config.include Warden::Test::Helpers # login_as, logout methods in Capybara specs

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
    OmniAuth.config.test_mode = true
    Warden.test_mode!
  end
  config.before :each do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before :each, js: true do
    DatabaseCleaner.strategy = :truncation
  end

  config.append_after :each do
    DatabaseCleaner.clean
  end
  config.after :suite do
    OmniAuth.config.test_mode = false
    Warden.test_reset!
  end
end
