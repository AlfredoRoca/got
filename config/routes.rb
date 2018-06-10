Rails.application.routes.draw do
  resources :houses
  get 'importer/form'
  post 'importer/upload'

  resources :characters do
    member do
      get :family
    end
  end

  root to: 'home#index'
end
