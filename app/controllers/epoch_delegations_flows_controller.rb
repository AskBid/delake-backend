class EpochDelegationsFlowsController < ApplicationController

	def show
		edf_json = JSON.parse(EpochDelegationsFlow.first.json)
		render json: edf_json
	end

	def index
		edfs= EpochDelegationsFlow.all
		render json: edfs, only: [:id, :epochno]
	end

	private

	def epoch_delegations_flow_params
		params.require()
	end
end