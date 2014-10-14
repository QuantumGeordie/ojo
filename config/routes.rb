Rails.application.routes.draw do
  get 'ojo' => 'ojo#index'

  resources :ojo
end
