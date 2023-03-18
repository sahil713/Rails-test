Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  mount Converter::User => '/api'
  mount Converter::Event => '/event'
  mount Converter::Post => '/post'
  mount Converter::Blog => '/blog'

end
