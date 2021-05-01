class PoolsController < ApplicationController
	def index
		current_epoch = Block.current_epoch
		epochs = [(current_epoch-2)..(current_epoch-1)]
		@pool_epochs = PoolEpoch.where(epoch_no: epochs)
			.where("size > 1000000")
			# .where("blocks < 21600")
		pool_hash_ids = @pool_epochs.pluck(:pool_hash_id).uniq
		@pools = Pool.where(pool_hash_id: pool_hash_ids)

		render json: {
			pool_epochs: @pool_epochs.as_json(only: [:epoch_no, :pool_hash_id, :blocks_delta_pc]),
			pools: @pools.as_json(only: [:ticker, :pool_hash_id, :hash_hex])
		}
	end

	def tickers
		tickers = Pool.where.not(ticker: nil).pluck(:ticker)
		render json: tickers
	end
end