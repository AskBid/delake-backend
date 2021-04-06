class UserStakeController < ApplicationController
	def create
		user = User.find_by({username: params[:user_username]})
		binding.pry
		if user && user.id === current_user.id
			if params[:stake_address].include?('stake1')
				stake_address = StakeAddress.find_by(view: params[:stake_address])
				if stake_address
					user.stake_address = stake_address
					render  status: :ok 
				else
					render status: :not_found
				end
			elsif params[:stake_address].include?('addr1')
				# send url such "https://cardanoscan.io/address/#{params[:stake_address]}"
			end
		else
			render status: :unauthorized
		end
		binding.pry
	end
end