Rails.application.routes.draw do
  post '/auth/:provider/callback', to: 'sessions#create'
  get  '/auth/:provider/callback', to: 'sessions#create'
  get  '/', to: 'application#index'
  resources :users, only: [:show, :update]
end
