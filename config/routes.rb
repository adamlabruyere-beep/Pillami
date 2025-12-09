Rails.application.routes.draw do
  root to: "pages#home"

  get "/dashboard", to: "dashboard#index"
  get "reminders/by_date", to: "reminders#by_date"

  devise_for :users
  resources :device_tokens, only: :create


  resources :users do
    resources :reminders
    resources :sensations
    resources :notifications, only: %i[index update]
    resource :calendrier, only: [:show]
  end

  get "notifications/bell", to: "notifications#bell"


  resources :sensations, only: [:create, :destroy]

  resources :medicaments, only: [:create, :index]

  resources :pillatheques, only: :show do
    resources :pillatheque_medicaments, only: [:create, :destroy]
  end

  resource :entourage, only: [:show, :create, :destroy] do
    resources :entourage_members, only: [:create, :destroy]
  end
end
