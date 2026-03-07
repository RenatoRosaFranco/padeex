# frozen_string_literal: true

Rails.application.routes.draw do

  # API.
  namespace :api do
    namespace :v1 do
      get "healthcheck", to: "healthcheck#show"

      namespace :auth do
        post "sign_in", to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
        get "me", to: "me#show"
      end

      # Scheduling.
      resources :courts, only: [:index, :create, :update] do
        resource :availability, only: [:show], controller: "availability"
        resources :bookings, only: [:create]
        resources :time_blocks, only: [:index, :create, :destroy]
      end
      resources :bookings, only: [:destroy]
    end
  end

  # Component previews (development only).
  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end

  # Payment webhooks (no CSRF, no auth).
  post "webhooks/stripe",  to: "webhooks/stripe#create"
  post "webhooks/openpix", to: "webhooks/openpix#create"

  # Root.
  root "landing#index"
  resource :waitlist, only: [:create]
  resource :investment_interest, only: [:create], path: "investimento"

  # Blog
  namespace :blog do
    resources :posts, only: [:index, :show]
  end

  # Explore
  get "explore", to: "explore#index", as: :explore

  # Store
  get "loja",     to: "store#index", as: :loja
  get "loja/:id", to: "store#show",  as: :loja_produto

  # Newsletter opt-out (public, no auth required).
  get "newsletter/cancelar/:token", to: "newsletter/unsubscribes#show", as: :newsletter_unsubscribe

  # Privacy.
  get "privacy/data-deletion", to: "privacy#data_deletion", as: :data_deletion

  # Landing pages.
  get "para-atletas",      to: "segments#show", as: :para_atletas,      defaults: { slug: "athletes"  }
  get "para-clubes",       to: "segments#show", as: :para_clubes,       defaults: { slug: "clubs"    }
  get "para-empresas",     to: "segments#show", as: :para_empresas,     defaults: { slug: "companies" }
  get "para-investidores", to: "segments#show", as: :para_investidores, defaults: { slug: "investors" }
  get "para-marcas",       to: "segments#show", as: :para_marcas,       defaults: { slug: "brands"   }

  # 2FA challenge during login.
  get  "conta/verificacao-2fa", to: "users/two_factor#new",    as: :new_user_two_factor
  post "conta/verificacao-2fa", to: "users/two_factor#create",  as: :user_two_factor

  # Devise.
  devise_for :users,
    path: "conta",
    path_names: { sign_in: "entrar", sign_out: "sair", sign_up: "cadastrar" },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords",
      omniauth_callbacks: "users/omniauth_callbacks"
    }

  # Onboarding wizard.
  namespace :onboarding do
    resource :personal_info, only: [:edit, :update], path: "dados-pessoais"
    resource :account_type,  only: [:edit, :update], path: "tipo-de-conta"
    resource :profile,       only: [:edit, :update], path: "perfil"
    get "username-check", to: "username_checks#show", as: :username_check
  end

  # Dashboard.
  get "/dashboard",                   to: "dashboard#index", as: :dashboard
  get "/dashboard/encontrar-partidas", to: "dashboard#index", as: :dashboard_encontrar_partidas, defaults: { page: "encontrar-partidas" }
  get "/dashboard/artigos",            to: "dashboard#index", as: :dashboard_artigos,   defaults: { page: "artigos" }
  get "/dashboard/aulas",              to: "dashboard#index", as: :dashboard_aulas,     defaults: { page: "aulas" }
  get "/dashboard/ranking",            to: "dashboard/ranking#index", as: :dashboard_ranking
  get   "/meu-perfil",        to: "dashboard/profiles#show",   as: :dashboard_meu_perfil
  get   "/meu-perfil/editar", to: "dashboard/profiles#edit",   as: :edit_my_profile
  patch "/meu-perfil",        to: "dashboard/profiles#update", as: :my_profile
  put   "/meu-perfil",        to: "dashboard/profiles#update"
  get   "/perfil/:id",        to: "profiles#show",             as: :public_profile
  get "/dashboard/analytics",          to: "analytics#index", as: :dashboard_analytics

  # Scheduling + clubs (within dashboard namespace).
  namespace :dashboard do
    get "feed",   to: "feed#index",    as: :feed
    get "amigos", to: "friends#index", as: :friends
    get "indicacoes", to: "referrals#index", as: :referrals
    resources :follows, only: [:create, :destroy, :update], path: "seguir"
    get "termos-e-condicoes",        to: "legal#terms",   as: :terms
    get "politicas-de-privacidade",  to: "legal#privacy", as: :privacy
    # Static content pages.
    get "glossario", to: "glossary#index", as: :glossary

    # For regular users: browse clubs and their courts.
    resources :clubs, only: [:index, :show]

    # For club users: tournament management.
    resources :tournaments, path: "torneios" do
      resources :categories, path: "categorias", controller: "tournament_categories" do
        resources :registrations, path: "inscricoes",
                  controller: "tournament_category_registrations",
                  only: [:create, :update, :destroy]
        resources :groups, path: "grupos",
                  controller: "tournament_category_groups",
                  only: [:create, :update, :destroy] do
          resources :memberships, path: "duplas",
                    controller: "tournament_group_memberships",
                    only: [:create, :destroy]
        end
        resources :matches, path: "jogos",
                  controller: "tournament_category_matches"
      end
    end

    # For club users: instructor management.
    resources :instructors, path: "instrutores"

    # For club users: week-view calendar of court bookings.
    resources :reservas, only: [:index, :destroy]

    # For club users: manage their own courts + per-court bookings.
    resources :courts, only: [:index, :new, :create, :edit, :update], path: "quadras" do
      resource  :reservation, only: [:new, :create], path: "reservar"
      resources :bookings, only: [:index, :destroy], path: "agendamentos", controller: "court_bookings"
    end

    # For all users: their own bookings.
    resources :bookings, only: [:index, :destroy], path: "minhas-reservas"

    # 2FA settings.
    resource :two_factor, only: [:show, :new, :create, :destroy], path: "seguranca/2fa", controller: "two_factor"

    # Notifications.
    resources :notifications, only: [:index] do
      collection { patch :mark_all_read }
      member      { patch :mark_read }
    end

    # Payments.
    namespace :payments do
      resources :checkouts, only: [:create]
      resources :pix,       only: [:show]
    end
    resources :orders, only: [:index], path: "pedidos"

    # For brand users.
    namespace :brands do
      get "insights", to: "insights#index", as: :insights
      get "looker",   to: "looker#index",   as: :looker_index
      resources :products,     path: "produtos",    as: :products
      resources :integrations, path: "integracoes", as: :integrations, only: [:index, :create, :update, :destroy]
    end

    # System admin: manage all courts and time blocks.
    namespace :admin do
      resources :courts, only: [:index, :new, :create, :edit, :update], path: "quadras" do
        resources :time_blocks, only: [:index, :create, :destroy], path: "bloqueios"
      end
      resources :feature_flags, only: [:index], path: "feature-flags" do
        collection { patch :toggle }
      end
    end
  end
end
