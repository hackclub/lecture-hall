class WorkshopsController < ApplicationController

  def index
    path = workshops_path.join('README.md')

    render_md_file(path)
  end

  def handle_root_request
    begin
      request_path = params[:path]
      request_path << ".#{params[:format]}" if params[:format]
      path = workshops_path.join(request_path)

      file_exists = File.exist?(path)
      is_workshop = File.directory?(path)

      if file_exists
        if is_workshop
          if trailing_slash?
            render_workshop path
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
      raise ActionController::RoutingError, 'File Not Found'
    end
  end

  def render_workshop_file
    begin
      workshop = params[:workshop]
      file = params[:file]
      path = workshops_path.join(workshop, file)

      deliver_file path
    rescue Errno::ENOENT, ActionController::MissingFile
      raise ActionController::RoutingError, 'File Not Found'
    end
  end

  private

  def render_workshop(workshop_path)
    begin
      path = workshops_path.join(workshop_path, 'README.md')
      @title = File.basename(workshop_path).to_s.humanize.titleize
      @metadata_page_name = @title
      @metadata_page_category = 'Workshop'
      @metadata_should_not_track_page = true if signed_in?

      render_md_file path

      url = request.url
      analytics.track_workshop_view(@title, url) if signed_in?
    rescue Errno::ENOENT
      raise ActionController::RoutingError, 'Workshop Not Found'
    end
  end

  def deliver_file(path)
    begin
      if File.extname(path) == '.md'
        @title = File.basename path
        render_md_file path
      else
        send_file path
      end
    rescue Errno::ENOENT
      raise ActionController::RoutingError, 'Workshop Not Found'
    end
  end

  def render_md_file(path)
    contents = File.read(path)
    md = MarkdownService.new

    @workshop_sidebar_html = md.render_sidebar(contents).html_safe
    @workshop_html = md.render(contents).html_safe

    render :show_md_file
  end

  def workshops_path
    Rails.root.join('vendor', 'hackclub', 'workshops')
  end
end
