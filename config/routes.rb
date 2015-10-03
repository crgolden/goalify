Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks',
                                   registrations: 'users/registrations'}
  authenticated :user do
    root to: 'pages#home', as: 'authenticated_root'
  end
  root 'pages#welcome'

  get 'pages/about' => 'pages#about'

  resources :goals do
    resources :comments, shallow: true
  end

  scope '/admin' do
    resources :users do
      resources :tokens, only: [:index]
    end
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

end
