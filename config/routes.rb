Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/airports/prepare_planes', to: 'airports#prepare_planes'

  get '/airports/planes_on_ready', to: 'airports#planes_on_ready'

  resources :airports, except: [:new, :edit]
  
  


end
