Rails.application.routes.draw do
  use_doorkeeper
  devise_for :accounts
  root to: "accounts#index"

  resources :accounts, only: %i[index edit update destroy] do
    get :current, on: :collection
  end
end
