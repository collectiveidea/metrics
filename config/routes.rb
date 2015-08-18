Rails.application.routes.draw do
  resources :metrics, only: [:index, :show, :new, :create]

  post "slack" => "slack#slash_command"

  root to: redirect("metrics", status: 302)
end
