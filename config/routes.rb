Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :pools, only: [:index]
  resources :epoch_delegations_flows, only: [:index, :show]
end
