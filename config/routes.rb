Rails.application.routes.draw do
  resources :metrics

  post "slack" => "slack#slash_command"

  root to: redirect("metrics", status: 302)
end
