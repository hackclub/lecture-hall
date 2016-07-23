Rails.application.routes.draw do
  get '/', to: 'workshops#index'
  get '/:workshop/', to: 'workshops#render_workshop'
  get '/:workshop/*file', to: 'workshops#render_file', constraints: { file: /.*/ }
end
