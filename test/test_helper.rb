ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    # Analytics setup
    @cached_analytics_backend = AnalyticsService.backend
    AnalyticsService.backend = FakeAnalyticsRuby.new

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

  def teardown
    AnalyticsService.backend = @cached_analytics_backend
  end

  # Analytics assertions
  def assert_has_tracked(event_name, user=nil, properties=nil)
    res = AnalyticsService.backend
      .tracked_events_for(user)
      .named(event_name)
      .has_properties?(properties)

    assert(
      res==true,
      "Expected '#{ event_name }' to have been tracked with appropriate user and params"
    )
  end

  def assert_has_identified(user, traits=nil)
    res = AnalyticsService.backend.has_identified?(user, traits)
    assert(res==true, "Expected user ID #{ user.id } to have been identified with appropriate traits")
  end
end
