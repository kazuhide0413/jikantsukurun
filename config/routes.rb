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

    get :line_notification
    patch :enable_line_notification
    patch :disable_line_notification
  end

  ## 静的ページ
  get "guide", to: "guide#index"

  ## システム
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
