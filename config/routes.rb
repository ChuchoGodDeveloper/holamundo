Rails.application.routes.draw do
  # Esto le dice a Rails que la página principal es tu "Hola Mundo"
  root 'welcome#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
end