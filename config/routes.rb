Rails.application.routes.draw do
  root to: 'unauthenticated#index'
  get  '/status', to: 'application#status'

  post '/auth/:provider/callback', to: 'sessions#create'
  get  '/auth/:provider/callback', to: 'sessions#create'

  resources :users, only: [:show] do
    resources :tags, only: [:create, :destroy]
  end

  resources :connections, only: [:index, :show] do
    member do
      get '/tag_cloud' => 'connections#tag_cloud'
    end
  end
  resources :tag_library, only: [:show], param: :category
end
