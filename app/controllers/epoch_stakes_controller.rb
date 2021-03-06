class EpochStakesController < ApplicationController
	def index
		user = User.find_by({username: params[:user_username]}) if params[:user_username]
		stake_address = params[:stake_address_view]
		stake_address_ids = params[:stake_address_ids].split(',') if params[:stake_address_ids]
		@current_epoch = Block.last
		epochs = ((@current_epoch.epoch_no-2)..@current_epoch.epoch_no)

		if user
			user_epoch_stakes(user, epochs)
		elsif !stake_address && !params[:user_username] && !stake_address_ids
			epoch_stakes_from_random_address(epochs)
		elsif stake_address_ids
			@epoch_stakes = EpochStake.where(addr_id: stake_address_ids).where(epoch_no: epochs)
		else # if stake_address.include?('stake1') || stake_address.include?('addr1')
			epoch_stakes_from_addresses(stake_address, epochs)
		end

		if @epoch_stakes
			render json: {
				epoch_stakes: EpochStakeDefaultSerializer.new(@epoch_stakes).to_live_rewards_json,
				last_update: BlockSerializer.new(@current_epoch).to_json
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

	def sample
		@current_epoch = Block.last
		epochs = ((@current_epoch.epoch_no-2)..@current_epoch.epoch_no)
		amount = params[:amount].to_i
		if amount < 20000000000 && amount > 0
			amount = amount * 1000000
		else 
			amount = 150000000000
		end
		epoch_stake = EpochStake.where(epoch_no: epochs.last).where("amount > ?", amount).order(amount: :asc).limit(1)
		@epoch_stakes = EpochStake.where(addr_id: epoch_stake.first.addr_id).where(epoch_no: epochs)
		if @epoch_stakes
			render json: {
				epoch_stakes: EpochStakeDefaultSerializer.new(@epoch_stakes).to_live_rewards_json,
				last_update: BlockSerializer.new(@current_epoch).to_json
			}, status: :ok
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

	def epoch_stakes_from_addresses(address, epochs)
		stake_address = StakeAddress.find_by_any_addr(address)
		@epoch_stakes = stake_address ? stake_address.epoch_stakes.where(epoch_no: epochs) : nil
	end
end