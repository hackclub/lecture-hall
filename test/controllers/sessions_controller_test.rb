require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # create

  test 'creates a user' do
    orig = User.count
    get '/auth/github/callback'

    assert_equal(orig+1, User.count)
  end

  test 'creates a session' do
    get '/'

    assert_equal(nil, session[:user_id])

    get '/auth/github/callback'

    assert_not_equal(nil, session[:user_id])
  end

  test 'records correct user details' do
    get '/auth/github/callback'
    user = User.last

    assert_equal(user.name, 'Prophet Orpheus')
    assert_equal(user.email, 'prophetorpheus@hackclub.com')
  end

  test 'updates user details on login' do
    NEW_NAME = 'Mr. Robot'
    NEW_EMAIL = 'different@hackclub.com'

    # FYI: @mock_auth is declared in test_helper.rb and is used as the auth hash
    # when using OmniAuth in tests. This verified that our new values aren't
    # already in the auth hash.
    assert_not_equal @mock_auth[:info][:name], NEW_NAME
    assert_not_equal @mock_auth[:info][:email], NEW_EMAIL

    # Confirm that the user created with the default auth hash doesn't match our
    # new values
    get '/auth/github/callback'
    old_user = User.last

    assert_not_equal old_user.name, NEW_NAME
    assert_not_equal old_user.email, NEW_EMAIL

    sign_out

    # Try changing just the name
    @mock_auth[:info][:name] = NEW_NAME

    get '/auth/github/callback'
    updated_user = User.last

    assert_equal NEW_NAME, updated_user.name
    assert_equal @mock_auth[:info][:email], updated_user.email # Email hasn't changed yet

    sign_out

    # Now for the email
    @mock_auth[:info][:email] = NEW_EMAIL

    get '/auth/github/callback'
    updated_user = User.last

    assert_equal NEW_NAME, updated_user.name
    assert_equal NEW_EMAIL, updated_user.email
  end

  test 'tracks sign in in analytics' do
    get '/auth/github/callback'

    assert_has_tracked_event(AnalyticsService::USER_SIGN_IN)

  end

  test 'redirects user to root' do
    get '/auth/github/callback'
    assert_redirected_to '/'
  end

  # destroy

  test 'clears the session' do
    get '/auth/github/callback'

    assert_not_equal(nil, session[:user_id])

    get '/sign_out'

    assert_equal(nil, session[:user_id])
  end

  test 'tracks sign out in analytics' do
    get '/auth/github/callback'

    user = User.last

    get '/sign_out'

    assert_has_tracked_event(AnalyticsService::USER_SIGN_OUT, user)
  end

  test 'redirects to homepage' do
    get '/auth/github/callback'
    get '/sign_out'

    assert_redirected_to '/'
  end
end
