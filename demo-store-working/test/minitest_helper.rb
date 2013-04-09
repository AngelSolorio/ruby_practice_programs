ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"
require "minitest/rails/capybara"

# Add `gem "minitest-rails-capybara"` to the test group of your Gemfile
# and uncomment the following if you want Capybara feature tests
# require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def stub_current_admin(id = 100)
    ApplicationController.class_exec(id) do |id|
      body = -> { @admin ||= Admin.find id }
      define_method :current_admin, body
    end
  end
  
  def destroy_session!
    ApplicationController.class_eval do
      define_method :admin_logged?, -> { false }
    end
  end
end

class MiniTest::Unit::TestCase
  include Rails.application.routes.url_helpers
  include Capybara::RSpecMatchers
  include Capybara::DSL
end
