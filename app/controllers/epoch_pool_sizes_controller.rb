class EpochPoolSizesController < ApplicationController
	def index

		@epoch_pool_sizes = EpochPoolSizes.epoch()
	end

	def epochs
		max = ActiveStake.maximum('epochno')
		min = ActiveStake.minimum('epochno')
		render json: {max: max, min: min}
	end

	private

	def epoch_pool_size_params
		params.require()
	end
end