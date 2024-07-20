Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get "dashboards", to: "dashboards#index"
    resources :users, only: [:destroy]
  end

  scope module: :public do
    devise_for :users
    root to: "homes#top"
    get "homes/about", to: "homes#about", as: :about
    resources :post_images, only: [:new, :create, :index, :show, :destroy]  do
      resources :post_comments, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
    end
    resources :users, only: [:show, :edit, :update]
    resource :map, only: [:show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
