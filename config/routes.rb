Rails.application.routes.draw do
  devise_for :users

  root to: "books#index"

  resources :books, only: [:index]
  resources :emails, only: [:new, :create]
  resources :images, only: [:create]
end
