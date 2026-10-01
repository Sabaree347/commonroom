Rails.application.routes.draw do
  devise_for :users
  get "home/index"
  resources :messages, only: [:index, :create]
  root "messages#index"
end