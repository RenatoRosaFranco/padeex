Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "landing#index"
  resource :waitlist, only: [:create]

  devise_for :users,
    path: "conta",
    path_names: { sign_in: "entrar", sign_out: "sair", sign_up: "cadastrar" },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  get "/dashboard", to: "dashboard#index", as: :dashboard
end
