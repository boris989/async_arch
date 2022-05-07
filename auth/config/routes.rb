Rails.application.routes.draw do
  devise_for :accounts
  root to: "accounts#index"

  resources :accounts, only: %i[index edit update destroy]
end
