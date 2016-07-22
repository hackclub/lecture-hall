class WorkshopsController < ApplicationController
  def render_file
    path = params[:file]
    ext = File.extname(path)

    # If they requested a directory (like if they went to /personal_website or
    # just /), this resolves that to the README.md file in that repo.
    #
    # If they're just asking for a regular file, resolve that to our submodule.
    if ext == '' # if they requested a directory, ex. /personal_website
      path = workshops_path.join(path, 'README.md')
      ext = '.md'
    else
      path = workshops_path.join(path)
    end

    if ext == '.md'
      contents = File.read(path)
      md = MarkdownService.new

      @workshop_toc_html = md.render_toc(contents).html_safe
      @workshop_html = md.render(contents).html_safe

      render :show
    else
      send_file path
    end
  end

  private

  def workshops_path
    Rails.root.join('vendor', 'hackclub', 'workshops')
  end
end
