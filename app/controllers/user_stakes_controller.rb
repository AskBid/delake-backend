class UserStakesController < ApplicationController

	def create
		user = User.find_by({username: params[:user_username]})
		authenticated = user === current_user
		#find address if user is authenticated or if is an unregistered request
		if authenticated
			current_epoch = Block.current_epoch
			if params[:stake_address] === ''
				current_epochs_stakes = EpochStake.epoch(current_epoch).where("amount > ?", 100000000000)
				stake_address = StakeAddress.find(current_epochs_stakes[rand(current_epochs_stakes.count)].addr_id)
			else # if params[:stake_address].include?('stake1') || 'addr1'
				stake_address = StakeAddress.find_by_any_addr(params[:stake_address])
			end
		end
		#get epoch_stake if stake_address was found
		if stake_address
			addr_added = user.add_stake_address(stake_address) if user && authenticated
			epochs = ((current_epoch-2)..current_epoch)
			@epoch_stakes = EpochStake.where(addr_id: stake_address.id).where(epoch_no: epochs)
			render json: EpochStakeDefaultSerializer.new(@epoch_stakes).to_live_rewards_json, status: :ok
		else #possible errors:
			if !authenticated
				render json: {error: "You are not logged in as #{params[:user_username]}"}, status: :unauthorized
			elsif !addr_added
				render json: {error: "That Stake Address is already associated with #{params[:user_username]}."}, status: :conflict
			elsif !stake_address
				render json: {error: 'The Stake Address entered was not found in the Cardano database'}, status: :not_found
			end
		end
	end

	def destroy
		user = User.find_by({username: params[:user_username]})
		if user && user.id === current_user.id
			user_stake = UserStake.find_by(user_id: user.id, stake_address_id: params[:addr_id])
			if user_stake
				user_stake.delete
				render json: {addr_id: params[:addr_id]}, status: :ok
			else
				render json: {error: `Stake Address not found for #{user.username}.`}, status: :not_found
			end
		else
			render json: {error: "User #{params[:user_username]} not authorised to delete or not existent."}, status: :unauthorized
		end
	end
end