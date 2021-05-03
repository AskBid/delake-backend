class EpochStakesController < ApplicationController
	def index
		user = User.find_by({username: params[:user_username]}) if params[:user_username]
		stake_address = params[:stake_address_view]
		@current_epoch = Block.last
		epochs = ((@current_epoch.epoch_no-2)..@current_epoch.epoch_no)

		if user
			user_epoch_stakes(user, epochs)
		elsif !stake_address && !params[:user_username]
			epoch_stakes_from_random_address(epochs)
		elsif stake_address.include?('stake1')
			epoch_stakes_from_address(stake_address, epochs)
		end

		if @epoch_stakes
			render json: {
				epoch_stakes: EpochStakeDefaultSerializer.new(@epoch_stakes).to_live_rewards_json,
				last_update: BlockSerializer.new(@current_epoch).serializable_hash
			}, status: :ok
		else 
			render status: :not_found
		end
	end

	def show
		@epoch_stake = EpochStake.find_by(id: params[:id])
		if @epoch_stake
			render json: EpochStakeDefaultSerializer.new(@epoch_stake).to_live_rewards_json, status: :ok
		else
			render status: :not_found
		end
	end

	private 

	def user_epoch_stakes(user, epochs)
		addr_ids = user.stake_addresses.ids
		@epoch_stakes = EpochStake.where(addr_id: addr_ids).where(epoch_no: epochs)
	end

	def epoch_stakes_from_random_address(epochs)
		selected_epochs_stakes = EpochStake.epoch(epochs.max).where("amount > ?", 150000000000)
		stake_address = StakeAddress.find(selected_epochs_stakes[rand(selected_epochs_stakes.count)].addr_id)
		@epoch_stakes = stake_address ? stake_address.epoch_stakes.where(epoch_no: epochs) : nil
	end

	def epoch_stakes_from_address(address, epochs)
		stake_address = StakeAddress.find_by(view: address)
		@epoch_stakes = stake_address ? stake_address.epoch_stakes.where(epoch_no: epochs) : nil
	end
end