class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_by(
      provider: auth['provider'],
      uid: auth['uid']
    ) || User.create_with_omniauth(auth)

    # Update user with latest info from GitHub
    new_attributes = {
      name: auth[:info][:name],
      email: auth[:info][:email],
      access_token: auth[:credentials][:token]
    }
    user.assign_attributes(new_attributes)
    user.save if user.changed?

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
