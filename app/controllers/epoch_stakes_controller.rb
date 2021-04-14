class EpochStakesController < ApplicationController
	def index
		user = User.find_by({username: params[:user_username]}) if params[:user_username]
		stake_address = StakeAddress.find_by(id: params[:stake_address_view]) if params[:stake_address_view]
		if user
			addr_ids = user.stake_addresses.ids
			current_epoch = Block.current_epoch
			epochs = ((current_epoch-2)..current_epoch)
			epoch_stakes = EpochStake.where(addr_id: addr_ids).where(epoch_no: epochs)
			render json: EpochStakeSerializer.new(epoch_stakes).to_live_rewards_json, status: :ok
		elsif stake_address
			current_epoch = Block.current_epoch
			epochs = ((current_epoch-2)..current_epoch)
			epoch_stakes = stake_address.epoch_stakes.where(epoch_no: epochs)
			render json: EpochStakeSerializer.new(epoch_stakes).to_live_rewards_json, status: :ok
		else
			render status: :not_found
		end
	end

	def show
		@epoch_stake = EpochStake.find_by(id: params[:id])
		if @epoch_stake
			render json: EpochStakeSerializer.new(@epoch_stake).to_live_rewards_json, status: :ok
		else
			render status: :not_found
		end
	end
end