class EpochStakesController < ApplicationController
	def index
		user = User.find_by({username: params[:user_username]}) if params[:user_username]
		stake_address = params[:stake_address_view]

		if user
			find_user_epoch_stakes(user)
		elsif stake_address === 'random'
			find_epoch_stakes_from_random_address
		elsif stake_address.include?('stake1')
			find_epoch_stakes_from_address(stake_address)
		end

		if @epoch_stakes
			render json: EpochStakeDefaultSerializer.new(@epoch_stakes).to_live_rewards_json, status: :ok
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

	def find_user_epoch_stakes(user)
		current_epoch = Block.current_epoch
		epochs = ((current_epoch-2)..current_epoch)
		addr_ids = user.stake_addresses.ids
		@epoch_stakes = EpochStake.where(addr_id: addr_ids).where(epoch_no: epochs)
	end

	def find_epoch_stakes_from_random_address
		current_epoch = Block.current_epoch
		epochs = ((current_epoch-2)..current_epoch)
		current_epochs_stakes = EpochStake.epoch(current_epoch).where("amount > ?", 100000000000)
		epoch_stakes_count = current_epochs_stakes.count
		stake_address = StakeAddress.find(current_epochs_stakes[rand(epoch_stakes_count)].addr_id)
		@epoch_stakes = stake_address ? stake_address.epoch_stakes.where(epoch_no: epochs) : nil
	end

	def find_epoch_stakes_from_address(address)
		current_epoch = Block.current_epoch
		epochs = ((current_epoch-2)..current_epoch)
		stake_address = StakeAddress.find_by(view: address)
		@epoch_stakes = stake_address ? stake_address.epoch_stakes.where(epoch_no: epochs) : nil
	end
end