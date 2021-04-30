class EpochDelegationsFlowsController < ApplicationController

	def show
		dele_flow = EpochDelegationsFlow.find_by(epochno: params[:id])
		if dele_flow
			edf_json = JSON.parse(dele_flow.json)
			render json: edf_json, status: :ok
		else
			render status: :not_found
		end
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