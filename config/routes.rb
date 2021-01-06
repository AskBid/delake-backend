Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :pools, only: [:index]
  resources :epoch_pool_sizes, only: [:index]

  get 'epoch_pool_sizes/epochs', to: 'epoch_pool_sizes#epochs'
end
