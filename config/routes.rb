Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post "/users", to: "users#create"
  get "/index", to: "users#index"
  post "/login", to: "auths#login"
  put "/update", to: "user#update"
  delete "/delete", to: "user#destroy"

  get "/slots", to: "slots#index"
  post "/slots", to: "slots#create" 

  resources :slots do
    patch 'booked', on: :member
  end
  
  resources :auths
  resources :users
  resources :slots 
  resources :appts

  #resources :users, except: [:new, :edit]

  # Defines the root path route ("/")
  # root "posts#index"
end
