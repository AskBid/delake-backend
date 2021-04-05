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
			render json: epoch_stakes, 
				include: [
					stake_address: {
						only: [:id, :view],
					},
					pool_hash: {
						only: [:id, :view], 
						include: [pool: {
							only: [:id, :ticker, :url]}
						]
					}
				],
				only: [:id, :amount, :epoch_no],
				methods: :calc_rewards,
				status: :ok
		else 
			render json: {}, status: :not_found
		end
		# render json: EpochStakeSerializer.new(epoch_stakes)
	end
end