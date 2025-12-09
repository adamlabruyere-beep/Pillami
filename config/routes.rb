Rails.application.routes.draw do

  root to: "pages#home"
  resources :calendriers, only: [:index]
  devise_for :users
  resources :users do
    resources :reminders
    resources :sensations
    resources :notifications, only: %i[index update]
    resource :calendrier, only: [:show]
  end
  get "reminders/by_date", to: "reminders#by_date"


  resources :devices, only: :create
  resources :device_tokens, only: :create

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :sensations

  resources :medicaments, only: [:create, :index]

  resources :pillatheques, only: :show do
    resources :pillatheque_medicaments, only: [:create, :destroy]
  end

  resource :entourage, only: [:show, :create, :destroy] do
    resources :entourage_members, only: [:create, :destroy]
  end
end
