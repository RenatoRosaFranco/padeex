# frozen_string_literal: true

Rails.application.routes.draw do

  # API.
  namespace :api do
    namespace :v1 do
      get "healthcheck", to: "healthcheck#show"
    end
  end

  # Root.
  root "landing#index"
  resource :waitlist, only: [:create]

  # Landing pages.
  get "para-atletas",  to: "segments#show", as: :para_atletas,  defaults: { slug: "athletes"  }
  get "para-clubes",   to: "segments#show", as: :para_clubes,   defaults: { slug: "clubs"    }
  get "para-empresas", to: "segments#show", as: :para_empresas, defaults: { slug: "companies" }

  # Devise.
  devise_for :users,
    path: "conta",
    path_names: { sign_in: "entrar", sign_out: "sair", sign_up: "cadastrar" },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      omniauth_callbacks: "users/omniauth_callbacks"
    }

  # Dashboard.
  get "/dashboard", to: "dashboard#index", as: :dashboard
  get "/dashboard/torneios", to: "dashboard#index", as: :dashboard_torneios, defaults: { page: "torneios" }
  get "/dashboard/encontrar-clubes", to: "dashboard#index", as: :dashboard_encontrar_clubes, defaults: { page: "encontrar-clubes" }
  get "/dashboard/encontrar-partidas", to: "dashboard#index", as: :dashboard_encontrar_partidas, defaults: { page: "encontrar-partidas" }
  get "/dashboard/reservar-partida", to: "dashboard#index", as: :dashboard_reservar_partida, defaults: { page: "reservar-partida" }
  get "/dashboard/artigos", to: "dashboard#index", as: :dashboard_artigos, defaults: { page: "artigos" }
  get "/dashboard/glossario", to: "dashboard#index", as: :dashboard_glossario, defaults: { page: "glossario" }
  get "/dashboard/aulas", to: "dashboard#index", as: :dashboard_aulas, defaults: { page: "aulas" }
  get "/dashboard/instrutores", to: "dashboard#index", as: :dashboard_instrutores, defaults: { page: "instrutores" }
  get "/dashboard/ranking", to: "dashboard#index", as: :dashboard_ranking, defaults: { page: "ranking" }
  get "/dashboard/minhas-partidas", to: "dashboard#index", as: :dashboard_minhas_partidas, defaults: { page: "minhas-partidas" }
  get "/dashboard/meu-perfil", to: "dashboard#index", as: :dashboard_meu_perfil, defaults: { page: "meu-perfil" }
  get "/dashboard/analytics", to: "analytics#index", as: :dashboard_analytics
end
