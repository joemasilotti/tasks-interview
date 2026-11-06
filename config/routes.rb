Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :tasks do
    resource :completion, only: [:create, :destroy], module: :tasks
  end
  root to: "tasks#index"
end
