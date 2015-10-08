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

# Example resource route with more complex sub-resources:
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', on: :collection
#     end
#   end

# Example resource route with concerns:
#   concern :toggleable do
#     post 'toggle'
#   end
#   resources :posts, concerns: :toggleable
#   resources :photos, concerns: :toggleable

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do

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
    end
  end
end
