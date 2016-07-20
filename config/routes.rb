Rails.application.routes.draw do
  get  '/status', to: 'application#status'
  api_version(module: 'V1', header: {name: 'API-VERSION', value: '1'}, default: true) do
    root to: 'unauthenticated#index'
    get '/privacy', to: 'unauthenticated#privacy'


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
  api_version(module: 'V2', header: {name: 'API-VERSION', value: '2'}) do
    resources :tags, only: [:index]

    resources :users, only: [] do
      resources :tags, only: [:index, :create], controller: 'user_tags'
    end
  end
end
