class EpochPoolSizesController < ApplicationController
	def index
		epoch_pool_sizes = EpochPoolSize.epoch(params[:epochno]).where('size > 35000000')
		render json: epoch_pool_sizes, only: [:size, :ticker]
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