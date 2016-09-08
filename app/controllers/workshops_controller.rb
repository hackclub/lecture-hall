class WorkshopsController < ApplicationController
  WORKSHOPS_WITHOUT_AUTH_WALL = [:personal_website].freeze

  def index
    path = workshops_path.join("README.md")

    render_md_file(path)
  end

  def handle_root_request
    request_path = params[:path]
    request_path << ".#{params[:format]}" if params[:format]
    path = workshops_path.join(request_path)

    file_exists = File.exist?(path)
    is_workshop = File.directory?(path)

    if file_exists
      if is_workshop
        if trailing_slash?
          workshop_name = request_path

          render_workshop workshop_name
        else
          ensure_trailing_slash
        end
      else
        deliver_file path
      end
    else
      raise ActionController::MissingFile
    end
  rescue Errno::ENOENT, ActionController::MissingFile
    raise ActionController::RoutingError, "File Not Found"
  end

  def render_workshop_file
    workshop = params[:workshop]
    file = params[:file]
    path = workshops_path.join(workshop, file)

    deliver_file path
  rescue Errno::ENOENT, ActionController::MissingFile
    raise ActionController::RoutingError, "File Not Found"
  end

  private

  def render_workshop(workshop_name)
    path = workshops_path.join(workshop_name, "README.md")

    @title = workshop_name.humanize.titleize

    @metadata_page_name = @title
    @metadata_page_category = "Workshop"
    @metadata_should_not_track_page = true if signed_in?

    if WORKSHOPS_WITHOUT_AUTH_WALL.include? workshop_name.to_sym
      @auth_wall = false
    end

    render_md_file path

    url = request.url
    analytics.track_workshop_view(@title, url) if signed_in?
  rescue Errno::ENOENT
    raise ActionController::RoutingError, "Workshop Not Found"
  end

  def deliver_file(path)
    if File.extname(path) == ".md"
      @title = File.basename path
      render_md_file path
    else
      send_file path
    end
  rescue Errno::ENOENT
    raise ActionController::RoutingError, "File Not Found"
  end

  def render_md_file(path)
    contents = File.read(path)
    md = MarkdownService.new

    @workshop_sidebar_html = md.render_sidebar(contents).html_safe
    @workshop_html = md.render(contents).html_safe

    render :show_md_file
  end

  def workshops_path
    Rails.root.join("vendor", "hackclub", "workshops")
  end
end
