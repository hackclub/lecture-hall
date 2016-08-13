require 'test_helper'

class AnalyticsServiceTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:basic)
    @analytics = AnalyticsService.new(@user)
  end

  test 'properly identifies users and stores traits' do
    traits = {
      name: @user.name,
      email: @user.email
    }

    assert_equal false, @analytics.backend.has_identified?(@user, traits)

    # This method should trigger an identify internally
    @analytics.track_user_sign_in

    assert_equal true, @analytics.backend.has_identified?(@user, traits)
  end
end
