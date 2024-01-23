Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :users, path: 'api/v1',
                     path_names: { sign_in: 'login',
                                   sign_out: 'logout',
                                   registration: 'signup' },
                     controllers: { sessions: 'api/v1/users/sessions',
                                    registrations: 'api/v1/users/registrations' },
                     defaults: { format: :json }
  namespace :api do
    namespace :v1 do
    end
  end
end
