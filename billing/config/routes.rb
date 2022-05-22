Rails.application.routes.draw do
  root to: 'dashboard#index'

  patch '/close_billing_cycle_and_open_new' => 'dashboard#close_billing_cycle_and_open_new'

  namespace :employee do
    get '/dashboard' => 'dashboard#index'
  end

  get '/login' => 'auth/oauth_sessions#new'
  get '/auth/:provider/callback' => 'auth/oauth_sessions#create'
  delete '/logout' => 'auth/oauth_sessions#destroy'
end
