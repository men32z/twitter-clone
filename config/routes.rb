Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users
  get "/all_users", to: "users#index", as: "users"
  resource :posts, only: [:new, :create]
  get "/:username", to: "users#show", as: "user_profile"
  get "/:username/following", to: "follows#index", as:"following"
  get "/:username/followers", to: "follows#index", as:"followers"
  post "/:username/follow", to: "follows#create", as:"follow"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
