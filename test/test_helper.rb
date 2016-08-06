ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    # OmniAuth Setup
    @mock_auth = OmniAuth::AuthHash.new(
      {
        provider: 'github',
        uid: '10101',
        info: {
          name: 'Prophet Orpheus'
        }
      }
    )

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = @mock_auth

    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
  end
end
