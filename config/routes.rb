Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users
  end  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  mount Converter::User => '/api'
  mount Converter::Event => '/event'
  mount Converter::Post => '/post'
  mount Converter::Blog => '/blog'

end
