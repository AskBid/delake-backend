class PoolsController < ApplicationController
	def index
	end

	def tickers
		tickers = Pool.where.not(ticker: nil).pluck(:ticker)
		render json: tickers
	end
end