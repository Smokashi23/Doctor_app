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
  # get "/slots/:id" to: "slots#"
  get "/my_slots", to: "slots#my_slots"
  resources :slots do
    patch 'book', to: "slots#book"  
  end

  resources :auths
  resources :users do 
     collection do
     post 'create_doctor', to:"users#create_doctor"
    end
  end
  resources :slots 
  resources :appointments

  #resources :users, except: [:new, :edit]

  # Defines the root path route ("/")
  # root "posts#index"
end
