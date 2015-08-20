class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  http_basic_authenticate_with(
    realm: ENV["BASIC_AUTH_REALM"],
    name: ENV["BASIC_AUTH_NAME"],
    password: ENV["BASIC_AUTH_PASSWORD"],
    if: -> { ENV["BASIC_AUTH_NAME"] && ENV["BASIC_AUTH_PASSWORD"] }
  )
end
