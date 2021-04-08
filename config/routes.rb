Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :pools, only: [:index]
  resources :users, param: :username, only: [:show, :create] do
  	resources :epoch_stake, only: [:index]
  	resources :user_stake, param: :addr_id, only: [:create, :new, :destroy]
  end 
  resources :epoch_delegations_flows, only: [:index, :show]
  resources :blocks, only: [:show]

  post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
end
