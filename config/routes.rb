Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks',
                                   registrations: 'users/registrations'}
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection
  end

  root 'high_voltage/pages#show', id: 'home'

  resources :goals, concerns: :paginatable
  resources :scores, concerns: :paginatable, only: [:show, :index]
  resources :subscriptions, concerns: :paginatable, except: [:show, :new]
  resources :comments, concerns: :paginatable
  resources :tokens, only: [:show, :destroy]
  resources :users, concerns: :paginatable, only: [:show, :index] do
    resources :tokens, only: [:index]
  end

  scope :admin, as: :admin do
    resources :users, concerns: :paginatable, except: [:show, :index]
  end

  namespace :api, defaults: {format: 'json'} do

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :goals, concerns: :paginatable
      resources :scores, concerns: :paginatable, only: [:show, :index]
      resources :subscriptions, concerns: :paginatable, except: [:show, :new]
      resources :comments, concerns: :paginatable
      resources :tokens, only: [:show, :destroy]
      resources :users, concerns: :paginatable do
        resources :tokens, only: [:index]
      end
    end

  end
end
