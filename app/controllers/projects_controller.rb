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
  end

  private

  def project_params
    params.permit(:name, :live_url)
  end
end
