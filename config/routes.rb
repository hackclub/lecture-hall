Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  get '/', to: 'workshops#index'
  get '/:workshop/*file', to: 'workshops#render_workshop_file', constraints: { file: /.*/ }
  get '/:path/', to: 'workshops#handle_root_request'
end
