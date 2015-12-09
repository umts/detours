Rails.application.routes.draw do
  root 'posts#index'

  resources :posts,  except: :show do
    collection do
      get :all
    end
  end
  resources :routes, except: :show do
    collection do
      get :all
    end
    member do
      get :posts
    end
  end
  resources :users, except: :show

  unless Rails.env.production?
    get  'sessions/dev_login', to: 'sessions#dev_login', as: :dev_login
    post 'sessions/dev_login', to: 'sessions#dev_login'
  end
  get 'sessions/unauthenticated', to: 'sessions#unauthenticated', as: :unauthenticated_session
  get 'sessions/destroy', to: 'sessions#destroy', as: :destroy_session
end
