class WorkshopsController < ApplicationController
  before_action :ensure_trailing_slash, only: :render_workshop

  def index
    path = workshops_path.join('README.md')

    render_md_file(path)
  end

  def render_workshop
    begin
      workshop = params[:workshop]
      path = workshops_path.join(workshop, 'README.md')

      @title = workshop.humanize.titleize
      render_md_file(path)
    rescue Errno::ENOENT
      raise ActionController::RoutingError, 'Workshop Not Found'
    end
  end

  def render_file
    begin
      workshop = params[:workshop]
      file = params[:file]

      path = workshops_path.join(workshop, file)

      if File.extname(file) == '.md'
        @title = file
        render_md_file(path)
      else
        send_file path
      end
    rescue Errno::ENOENT, ActionController::MissingFile
      raise ActionController::RoutingError, 'File Not Found'
    end
  end

  private

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
