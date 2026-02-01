Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  authenticated :user do
    root to: "habits#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "static_pages#top"
  end

  resources :habits do
    member do
      post :toggle_record, to: "daily_habit_records#toggle"
    end
  end

  resources :daily_sessions, only: [ :index ] do
    collection do
      post :return_home
      post :bedtime
    end
  end

  resource :settings, only: [ :show ] do
    get :edit_name
    patch :update_name
    get :edit_line_notify
    patch :update_line_notify
  end

  post "/line/webhook", to: "line/webhooks#callback"

  namespace :internal do
    namespace :line do
      post :daily_effective_time, to: "notifications#daily_effective_time"
    end
  end

  get "guide", to: "guide#index"

  get "up" => "rails/health#show", as: :rails_health_check

  get "/service-worker.js" => "rails/pwa#service_worker", as: :pwa_service_worker, defaults: { format: :js }
  get "/manifest.json"     => "rails/pwa#manifest",       as: :pwa_manifest,       defaults: { format: :json }
end
