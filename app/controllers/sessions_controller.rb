class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_by(
      provider: auth['provider'],
      uid: auth['uid']
    ) || User.create_with_omniauth(auth)

    # Update user with latest info from GitHub
    auth_info_params = ActionController::Parameters.new(auth)
                  .require(:info)
                  .permit(:name, :email)
    user.assign_attributes(auth_info_params)
    user.save if user.changed?

    sign_in user
    analytics.track_user_sign_in

    redirect_to request.env['omniauth.origin'] || '/', notice: 'Signed in!'
  end

  def destroy
    analytics.track_user_sign_out
    sign_out

    redirect_to '/', notice: 'Signed out!'
  end
end
