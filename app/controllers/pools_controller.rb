class PoolsController < ApplicationController
	def index
	end

	def tickers
		tickers = Pool.all.pluck(:ticker).filter{|t| t.length < 6}
		render json: tickers
	end
end