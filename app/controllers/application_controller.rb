class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  private

  def ensure_trailing_slash
    redirect_to url_for(params.permit.merge(trailing_slash: true)) unless trailing_slash?
  end

  def trailing_slash?
    request.env['REQUEST_URI'].match(/[^\?]+/).to_s.last == '/'
  end
end
