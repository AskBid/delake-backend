class UserStakeController < ApplicationController
	def create
		user = User.find_by({username: params[:user_username]})
		if user && user.id === current_user.id
			if params[:stake_address].include?('stake1') && (params[:stake_address].lenght === 59)
				stake_address = StakeAddress.find_by(view: params[:stake_address])
				if stake_address
					user.stake_address = stake_address
					render EpochStakeSerializer.new(epoch_stakes).to_live_rewards_json, status: :ok 
				else
					render status: :not_found
				end
			elsif params[:stake_address].include?('addr1') && (params[:stake_address].lenght === 103)
				# send url such "https://cardanoscan.io/address/#{params[:stake_address]}"
			else
				# you enteres a wrong address format 
				# correct format: "stake1uyhhmypjdwtmkchfwc99uvhpjppddd9d7e6xt9hql3p4x3sxf04aa"
			end
		else
			render status: :unauthorized
		end
	end
end