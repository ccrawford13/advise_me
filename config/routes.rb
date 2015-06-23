Rails.application.routes.draw do

  devise_for :users

  get 'welcome/about'
  get 'welcome/contact'

  root to: 'welcome#index'
  
end
