class EpochStakeController < ApplicationController
	def index
		user = User.find_by({username: params[:user_username]})
		if user
			addr_ids = user.stake_addresses.ids
			current_epoch = Block.current_epoch
			epochs = ((current_epoch-2)..current_epoch)
			# epoch_stakes = EpochStake.where(addr_id: addr_ids).where(epoch_no: epochs).group_by(&:epoch_no)
			# if I use group_by here the data is ready to use at front end, but can't use serializer
			# without group_by front-end will need grouping by epoch but we can serialize including other models in epoch stakes 
			epoch_stakes = EpochStake.where(addr_id: addr_ids).where(epoch_no: epochs)
			render json: EpochStakeSerializer.new(epoch_stakes).to_live_rewards_json, status: :ok
		else 
			render status: :not_found
		end
	end
end