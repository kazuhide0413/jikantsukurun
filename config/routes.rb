Rails.application.routes.draw do
  # 開発環境でのみメール確認用画面を有効化
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  ## devise認証
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  ## メイン機能
  root "static_pages#top"

  resources :habits do
    member do
      post :toggle_record, to: "daily_habit_records#toggle"
    end
  end

  resources :daily_sessions, only: [:index] do
    collection do
      post :return_home
      post :bedtime
    end
  end

  resource :settings, only: [:show] do
    get :edit_name
    patch :update_name
    patch :generate_line_link_token
    patch :send_line_test
  end

  post "/line/webhook", to: "line_webhook#create"

  namespace :internal do
    namespace :line do
      post :daily_effective_time, to: "notifications#daily_effective_time"
    end
  end

  ## 静的ページ
  get "guide", to: "guide#index"

  ## システム
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
