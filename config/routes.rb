Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :pools, only: [:index]
  resources :users, param: :username, only: [:show, :create] do
  	resources :epoch_stakes, only: [:index]
  	resources :user_stakes, param: :addr_id, only: [:create, :new, :destroy]
    resources :user_pool_hashes, only: [:create, :index]
  end
  resources :epoch_delegations_flows, only: [:index, :show]
  resources :blocks, only: [:show]
  resources :epoch_stakes, only: [:show]
  resources :user_pool_hashes, only: [:show]

  post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
  get '/pools/tickers', to: 'pools#tickers'
end
