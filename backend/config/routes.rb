Rails.application.routes.draw do
 
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # GET /api/v1/catalogs
  # GET /api/v1/nutritionists
  # POST /api/v1/appointments
  # PATCH /api/v1/appointments/:id
  # GET /api/v1/appointments
  # GET /api/v1/appointments/:id

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :catalogs, only: [:index]
      resources :nutritionists, only: [:index]
      resources :appointments, only: [:create, :update, :index, :show]
    end
  end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
