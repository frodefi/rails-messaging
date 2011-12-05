Messaging::Engine.routes.draw do
  resources :messages do
    member do
      delete 'trash'
      post 'untrash'
    end
    collection do
      delete 'trash'
    end
  end
  root to: 'messages#index'
end
