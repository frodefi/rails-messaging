Rails.application.routes.draw do

  devise_for :messaging_users

  devise_for :users

  mount Messaging::Engine => "/messaging"

  root to: 'home#index'
end
