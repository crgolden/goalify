Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations'}

  resources :goals do
    collection do
      get '(page/:page)', action: :index
      get 'search/(page/:page)', action: :search, as: :search
    end
    member do
      get 'comments/(page/:page)', action: :comments, as: :comments
      get 'scores/(page/:page)', action: :scores, as: :scores
      get 'subscribers/(page/:page)', action: :subscribers, as: :subscribers
    end
  end

  resources :users, except: [:edit, :update, :create, :new, :destroy] do
    collection do
      get '(page/:page)', action: :index
      get 'search/(page/:page)', action: :search, as: :search
    end
    member do
      get 'comments/(page/:page)', action: :comments, as: :comments
      get 'goals/(page/:page)', action: :goals, as: :goals
      get 'scores/(page/:page)', action: :scores, as: :scores
      get 'subscriptions/(page/:page)', action: :subscriptions, as: :subscriptions
      get 'tokens/(page/:page)', action: :tokens, as: :tokens
    end
  end

  scope :admin, as: :admin do
    resources :users, only: [:edit, :update, :create, :new, :destroy]
  end

  resources :comments, only: [:create, :destroy]
  resources :goals_users, only: [:create, :update, :destroy], as: :subscriptions
  resources :tokens, only: [:destroy]

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      resources :goals, except: [:new, :edit] do
        collection do
          get '(page/:page)', action: :index
          get 'search/(page/:page)', action: :search, as: :search
        end
        member do
          get 'comments/(page/:page)', action: :comments, as: :comments
          get 'scores/(page/:page)', action: :scores, as: :scores
          get 'subscribers/(page/:page)', action: :subscribers, as: :subscribers
        end
      end

      resources :users, except: [:new, :edit] do
        collection do
          get '(page/:page)', action: :index
          get 'search/(page/:page)', action: :search, as: :search
        end
        member do
          get 'comments/(page/:page)', action: :comments, as: :comments
          get 'goals/(page/:page)', action: :goals, as: :goals
          get 'scores/(page/:page)', action: :scores, as: :scores
          get 'subscriptions/(page/:page)', action: :subscriptions, as: :subscriptions
          get 'tokens/(page/:page)', action: :tokens, as: :tokens
        end
      end

      resources :comments, only: [:create, :destroy]
      resources :goals_users, only: [:create, :update, :destroy], as: :subscriptions
      resources :tokens, only: [:destroy]

    end
  end
end
