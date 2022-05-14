Rails.application.routes.draw do
  root to: 'dashboard#index'

  namespace :employee do
    get '/dashboard' => 'dashboard#index'
  end

  get '/login' => 'auth/oauth_sessions#new'
  get '/auth/:provider/callback' => 'auth/oauth_sessions#create'
  delete '/logout' => 'auth/oauth_sessions#destroy'
end
