Rails.application.routes.draw do
  devise_for :users

  root to: "books#index"

  resources :books, only: [:index, :create]
  resources :people, only: [:index, :create]
  resources :relationships, only: [:index, :create]
  resources :emails, only: [:new, :create]
  resources :images, only: [:create]
end
