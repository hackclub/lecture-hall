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

  test 'tracks sign in in analytics' do
    get '/auth/github/callback'

    assert_has_tracked(AnalyticsService::USER_SIGN_IN, User.last)
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
    get '/sign_out'

    assert_has_tracked(AnalyticsService::USER_SIGN_OUT, User.last)
  end

  test 'redirects to homepage' do
    get '/auth/github/callback'
    get '/sign_out'

    assert_redirected_to '/'
  end
end