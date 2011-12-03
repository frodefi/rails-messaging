Rails.application.routes.draw do

  mount Messaging::Engine => "/messaging"
end
