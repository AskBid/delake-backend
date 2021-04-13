class UserPoolHashesController < ApplicationController

  def create
    user = User.find_by({username: params[:user_username]})
    if user && user.id === current_user.id
      pool = Pool.find_by(ticker: params[:ticker])
      if pool
        @pool_hash = pool.pool_hash
      else
        @pool_hash = HashPool.find_by(ticker: params[:ticker]) if params[:ticker].include?('pool1')
      end
      if @pool_hash
        user.add_pool_hash(@pool_hash)
      else
        render json: {error: "#{params[:ticker]} Pool not found."}, status: :not_found
      end
    else
      render json: {error: "#{current_user} cannot add a pool to #{params[:user_username]}"}, status: :unauthorized
    end
    binding.pry
  end  

  def index
  	user = User.find_by({username: params[:user_username]})
  	if user
  		pool_hashes = user.pool_hashes
  		epoch_stake = EpochStake.find(params[:epoch_stake_id])

      render json: PoolHashSerializer.new(pool_hashes).to_compared_epoch_stakes(epoch_stake), status: :ok
  	else
      render status: :not_found
    end
  end

end