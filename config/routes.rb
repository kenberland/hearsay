Rails.application.routes.draw do
  post '/auth/:provider/callback', to: 'sessions#create'
  get  '/auth/:provider/callback', to: 'sessions#create'
  get  '/', to: 'application#index'
  resources :users, only: [:show] do
    resources :tags, only: [:create, :destroy]
  end
  resources :connections, only: [:show]
  resources :tag_library, only: [:show], param: :category
end
