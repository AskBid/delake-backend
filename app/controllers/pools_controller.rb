class PoolsController < ApplicationController
	def index
		current_epoch = Block.current_epoch
		epochs = [(current_epoch-21)..(current_epoch-1)]
		@pool_epochs = PoolEpoch.where(epoch_no: epochs)
		render json: @pool_epochs, only: [:epoch_no, :pool_hash_id, :total_stakes, :blocks, :size]
	end

	def tickers
		tickers = Pool.where.not(ticker: nil).pluck(:ticker)
		render json: tickers
	end
end