Rails.application.routes.draw do


  devise_for :users, :controllers => { registrations: 'registrations'}
  
  resources :users, only: [:show]

  get 'welcome/about'
  get 'welcome/contact'

  root to: 'welcome#index'

end
