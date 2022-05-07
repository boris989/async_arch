Rails.application.routes.draw do
  root to: 'tasks#index'

  get '/login' => 'auth/oauth_sessions#new'
  get '/auth/:provider/callback' => 'auth/oauth_sessions#create'
  delete '/logout' => 'auth/oauth_sessions#destroy'
end
