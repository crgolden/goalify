Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks',
                                   registrations: 'users/registrations'}
  resources :goals do
    resources :comments, shallow: true
  end

  resources :users, only: [:show, :index, :destroy] do
    resources :tokens, only: [:index]
  end

  scope '/admin' do
    resources :users, only: [:edit, :update, :create, :new]
  end

  resources :tokens, only: [:show, :destroy]

  namespace :api, defaults: {format: 'json'} do

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users do
        resources :tokens, only: [:index]
      end
      resources :goals do
        resources :comments, shallow: true
      end
      resources :tokens, only: [:show, :destroy]
    end

  end
end
