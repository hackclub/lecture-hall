Rails.application.routes.draw do
  get '/*file', to: 'workshops#render_file', constraints: { file: /.*/ }
end
