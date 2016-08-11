Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  get '/', to: 'workshops#index'
  get '/:workshop/*file', to: 'workshops#render_file', constraints: { file: /.*/ }
  get '/:file', to: 'workshops#send_root_file', constraints: { file: /.*\..*/ }
  get '/:workshop/', to: 'workshops#render_workshop'
end
