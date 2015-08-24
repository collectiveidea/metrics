Rails.application.routes.draw do
  resources :metrics do
    get "preview", on: :collection
  end

  post "slack" => "slack#slash_command"

  root to: redirect("metrics", status: 302)
end
