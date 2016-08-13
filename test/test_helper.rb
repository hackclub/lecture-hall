ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include SessionsHelper

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
  def assert_has_identified(user, traits=nil)
    res = AnalyticsService.backend.has_identified?(user, traits)
    assert(res==true, "Expected user ID #{ user.id } to have been identified with appropriate traits")
  end

  def assert_has_tracked_event(name, user=current_user, properties=nil)
    assert_has_tracked(true, :event, name, user, properties)
  end

  def assert_has_tracked_page_view(name, user=current_user, properties=nil)
    assert_has_tracked(true, :page_view, name, user, properties)
  end

  def assert_has_not_tracked_event(name, user=current_user, properties=nil)
    assert_has_tracked(false, :event, name, user, properties)
  end

  def assert_has_not_tracked_page_view(name, user=current_user, properties=nil)
    assert_has_tracked(false, :page_view, name, user, properties)
  end

  private

  def assert_has_tracked(expected, type, name, user=current_user, properties=nil)
    if type == :event
      actual = has_tracked_event?(name, user, properties)
    elsif type == :page_view
      actual = has_tracked_page_view?(name, user, properties)
    end

    if expected
      msg = "Expected '#{ name }' to have been tracked with correct user and parameters"
    else
      msg = "Expected '#{ name }' to not have been tracked"
    end

    assert_equal(expected, actual, msg)
  end

  # Analytics test helpers
  def has_tracked_event?(event_name, user=current_user, properties=nil)
    AnalyticsService.backend
      .tracked_events_for(user)
      .named(event_name)
      .has_properties?(properties)
  end

  def has_tracked_page_view?(page_name, user=current_user, properties=nil)
    AnalyticsService.backend
      .tracked_page_views_for(user)
      .named(page_name)
      .has_properties?(properties)
  end
end
