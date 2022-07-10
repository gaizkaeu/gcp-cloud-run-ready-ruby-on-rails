require 'lockup'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount Lockup::Engine, at: '/lockup' if Rails.env.production?
  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?

  if Rails.configuration.x.cypress
    namespace :cypress do
      delete 'cleanup', to: 'cleanup#destroy'
    end
  end

  get '/manifest.v1.webmanifest', to: 'statics#manifest', as: :webmanifest

  root to: 'main#index'


end
