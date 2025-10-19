Rails.application.routes.draw do
  ## devise認証
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  ## メイン機能
  root "static_pages#top"

  ## 静的ページ
  get "guide", to: "guide#index"

  ## システム
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
