Rails.application.routes.draw do


  devise_for :users, :controllers => { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks'}

  resources :users, only: [:show] do
    resources :students, except: [:index], shallow: true do
      collection { post :import }
      resources :notes, only: [:new, :create], shallow: true
    end
    resources :appointments, only: [:new, :create], shallow: true
  end

  get 'welcome/about'
  get 'welcome/contact'

  root to: 'welcome#index'
end
