Rails.application.routes.draw do
  root to: 'tasks#index'

  resources :tasks, only: %i[new create edit update]

  namespace :employee do
    resources :tasks, only: %i[index] do
      patch :complete, on: :member
    end
  end

  get '/login' => 'auth/oauth_sessions#new'
  get '/auth/:provider/callback' => 'auth/oauth_sessions#create'
  delete '/logout' => 'auth/oauth_sessions#destroy'
end
