class ProjectsController < ApplicationController
  def create
    project = current_user.projects.build(project_params)
    if project.save
      render json: project
    else
      render json: { errors: project.errors.full_messages }, status: 422
    end
  end

  def validate_github_url
    begin
      url = params[:url]

      client = Octokit::Client.new(access_token: current_user.access_token)
      repo = client.repository(parse_github_url(url))

      render json: { valid: true }
    rescue Octokit::NotFound
      render json: { valid: false }, status: 404
    rescue Octokit::InvalidRepository, ArgumentError
      render json: { valid: false }, status: 422
    end
  end

  private

  def parse_github_url(url)
    username, repo = URI(url).path.split('/').last(2)
    [username, repo].join('/')
  end

  def project_params
    params.permit(:name, :live_url)
  end
end
