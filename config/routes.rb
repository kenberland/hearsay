Rails.application.routes.draw do
  root to: 'unauthenticated#index'
  get  '/status', to: 'application#status'

  post '/auth/:provider/callback', to: 'sessions#create'
  get  '/auth/:provider/callback', to: 'sessions#create'

  resources :users, only: [] do
    resources :tags, only: [:create, :destroy]
  end

  resources :connections, only: [:index, :show] do
    member do
      get '/tag_cloud' => 'connections#tag_cloud'
    end
  end
  resources :tag_library, only: [:show], param: :category do
    resources :create, only: [:create], controller: :tag_library
  end

  get  '/browse', to: 'connections#browse'
  get  '/browse/:id', to: 'connections#get_absolute_user'
end
