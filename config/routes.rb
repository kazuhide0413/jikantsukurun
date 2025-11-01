Rails.application.routes.draw do
  ## devise認証
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  ## メイン機能
  root "static_pages#top"

  resources :habits do
    member do
      post :toggle_record, to: "daily_habit_records#toggle"
    end
  end

  resource :daily_session, only: [], controller: "daily_sessions" do
    post :return_home    # 帰宅ボタン
    post :bedtime        # 就寝ボタン
  end

  resource :settings, only: [:show] do
    get :edit_name
    patch :update_name
    # 将来的にLINE通知設定を追加
    # get :line
  end

  ## 静的ページ
  get "guide", to: "guide#index"

  ## システム
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
