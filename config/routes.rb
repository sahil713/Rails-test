Rails.application.routes.draw do
    devise_for :users
    resources :sessions

  # Defines the root path route ("/")
  # root "articles#index"
    scope :api  do
  mount Converter::User => '/'
  mount Converter::Event => '/'
  mount Converter::Post => '/'
  mount Converter::Blog => '/'
  end

end
