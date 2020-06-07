Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users
  resource :posts, only: [:new, :create]
  get "/:username", to: "users#show", as: "user_profile"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
