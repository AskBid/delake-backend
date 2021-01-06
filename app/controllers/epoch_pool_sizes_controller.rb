class EpochPoolSizesController < ApplicationController
	def index
		epoch_pool_sizes = EpochPoolSize.epoch(params[:epochno])
		binding.pry
		render json: epoch_pool_sizes, include: :pool, only: :size
	end

	def epochs
		max = EpochPoolSize.maximum('epochno')
		min = EpochPoolSize.minimum('epochno')
		render json: {max: max, min: min}
	end

	private

	def epoch_pool_size_params
		params.require()
	end
end