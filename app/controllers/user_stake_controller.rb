class UserStakeController < ApplicationController
	def create
		user = User.find_by({username: params[:user_username]})
		if params[:stake_address].include?('stake1')
			stake_address = StakeAddress.find_by(view: params[:stake_address])
		elsif params[:stake_address].include?('addr1')
			# send url such "https://cardanoscan.io/address/#{params[:stake_address]}"
		end
		binding.pry
	end
end