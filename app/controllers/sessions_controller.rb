class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_by(
      provider: auth['provider'],
      uid: auth['uid']
    ) || User.create_with_omniauth(auth)

    sign_in user

    redirect_to '/', notice: 'Signed in!'
  end

  def destroy
    sign_out
    redirect_to '/', notice: 'Signed out!'
  end
end
