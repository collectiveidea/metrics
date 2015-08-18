Rails.application.routes.draw do
  resources :metrics, only: [:index, :show, :new, :create]

  root to: redirect("metrics", status: 302)
end
