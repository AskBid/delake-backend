class PoolsController < ApplicationController
	def index
		current_epoch = Block.current_epoch
		epochs = [(current_epoch-20)..(current_epoch-1)]
		pool_hash_ids = Pool.where('producing_epochs > ?', 20*1.5)
			.where.not(performance: nil)
			.order(performance: :desc)
			.limit(100)
			.pluck(:pool_hash_id)
		binding.pry
		@pool_epochs = PoolEpoch.where(pool_hash_id: pool_hash_ids).where(epoch_no: epochs)
		# pool_hash_ids = @pool_epochs.pluck(:pool_hash_id).uniq
		@pools = Pool.where(pool_hash_id: pool_hash_ids)
		# binding.pry
		render json: {
			pool_epochs: @pool_epochs.as_json(only: [:epoch_no, :pool_hash_id, :blocks_delta_pc]),
			pools: @pools.as_json(only: [:ticker, :pool_hash_id, :hash_hex, :pool_addr, :performance, :avg_size, :avg_blocks])
		}
	end

	def tickers
		tickers = Pool.where.not(ticker: nil).pluck(:ticker)
		render json: tickers
	end
end