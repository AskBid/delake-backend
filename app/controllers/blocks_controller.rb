class BlocksController < ApplicationController
  def show
    if params[:id] === '0'
      render json: Block.current_epoch, status: :ok
    else
      render json: {error: 'show blocks only supported for last block'}, status: :not_acceptable
    end
  end

  def last_update
  	render json: Block.last.as_json(only: [:time, :epoch_no, :slot_no, :block_no, :epoch_slot_no])
  end
end