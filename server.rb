require 'sinatra'
require 'redcarpet'

renderer = Redcarpet::Render::HTML.new(render_options = {})
md = Redcarpet::Markdown.new(renderer, extensions = {})

get '/workshops/:name' do
	path = File.join('vendor/workshops/workshops/', params[:name], 'README.md')
	contents = File.read(path)
	md.render(contents)
end
