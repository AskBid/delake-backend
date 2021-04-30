class PoolsController < ApplicationController
	def index
		# current_epoch = Block.current_epoch
		# epochs = [(current_epoch - 21)..current_epoch]
		epochs = [260]
		@pool_epochs = PoolEpoch.where(epoch_no: epochs)
		binding.pry
		# @epoch_stakes = EpochStake.where(epoch_no: epochs)
		# @pools = PoolHash.all
		# render json: {
		# 	blocks: BlockSerializer.new(@blocks).serializable_hash,
		# 	epoch_stakes: EpochStakeSerializer.new(@epoch_stakes).serializable_hash,
		# 	pools: PoolHashSerializer.new(@pools).serializable_hash
		# }
		render json: PoolEpochSerializer.new(@pool_epochs).serializable_hash
	end

	def tickers
		tickers = Pool.where.not(ticker: nil).pluck(:ticker)
		render json: tickers
	end
end