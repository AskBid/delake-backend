class UserStakeController < ApplicationController
	def create
		user = User.find_by({username: params[:user_username]})
		if user && user.id === current_user.id
			stake_address = StakeAddress.find_by(view: params[:stake_address])
			if stake_address && user.stake_address = stake_address
				current_epoch = Block.current_epoch
				epochs = ((current_epoch-2)..current_epoch)
				epoch_stakes = EpochStake.where(addr_id: stake_address.id).where(epoch_no: epochs)
				render json: EpochStakeSerializer.new(epoch_stakes).to_live_rewards_json, status: :ok 
			else
				render json: {error: 'The Stake Address entered was not found in the Cardano database'}, status: :not_found
			end
		else
			render json: {error: "You are not logged in as #{params[:user_username]}"}, status: :unauthorized
		end
	end
end