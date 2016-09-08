class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  before_action :set_auth_wall

  def analytics
    @analytics ||= AnalyticsService.new(current_user)
  end

  private

  def set_auth_wall
    @auth_wall = !signed_in?
  end

  def ensure_trailing_slash
    redirect_to url_for(params.permit.merge(trailing_slash: true))
  end

  def trailing_slash?
    request.env['REQUEST_URI'].match(/[^\?]+/).to_s.last == '/'
  end
end
