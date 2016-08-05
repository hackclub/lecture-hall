require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
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

  test 'redirects to homepage' do
    get '/auth/github/callback'
    get '/sign_out'

    assert_redirected_to '/'
  end
end
