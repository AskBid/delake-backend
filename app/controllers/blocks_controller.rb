class BlocksController < ApplicationController
  def show
    if params[:id] === '0'
      render json: Block.current_epoch, status: :ok
    else
      render json: {error: 'show blocks only supported for last block'}, status: :not_acceptable
    end
  end
end