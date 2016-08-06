class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_by(
      provider: auth['provider'],
      uid: auth['uid']
    ) || User.create_with_omniauth(auth)

    sign_in user
    analytics.track_user_sign_in

    redirect_to '/', notice: 'Signed in!'
  end

  def destroy
    analytics.track_user_sign_out
    sign_out

    redirect_to '/', notice: 'Signed out!'
  end
end
