Rails.application.routes.draw do

  root to: "pages#home"
  get "reminders/by_date", to: "reminders#by_date"

  devise_for :users
  resources :users do
    resources :reminders
    resources :sensations
    resource :calendrier, only: [:show]
  end
  resources :sensations

  resources :medicaments, only: [:create, :index]

  resources :pillatheques, only: :show do
    resources :pillatheque_medicaments, only: [:create, :destroy]
  end

  resource :entourage, only: [:show, :create, :destroy] do
    resources :entourage_members, only: [:create, :destroy]
  end
end
