require 'rouge/plugins/redcarpet'

class MarkdownService
  class Renderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  def initialize
    @toc_renderer = Redcarpet::Render::HTML_TOC
    @renderer = Renderer.new(
      with_toc_data: true
    )

    @toc_parser = Redcarpet::Markdown.new(@toc_renderer)
    @parser = Redcarpet::Markdown.new(
      @renderer,
      autolink: true,
      tables: true,
      strikethrough: true,
      fenced_code_blocks: true,
    )
  end

  def render_toc(text)
    @toc_parser.render(text)
  end

  def render(text)
    @parser.render(text)
  end
end
