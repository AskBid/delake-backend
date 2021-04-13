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
        if user.add_pool_hash(@pool_hash)
          render json: {user_id: user.id, pool_hash_id: pool_hash.id }, status: :created
        else
          render json: {error: "Pool #{params[:ticker]} is already followed from #{params[:user_username]}."}, status: :not_acceptable
        end
      else
        render json: {error: "#{params[:ticker]} Pool not found."}, status: :not_found
      end
    else
      render json: {error: "#{current_user} cannot add a pool to #{params[:user_username]}"}, status: :unauthorized
    end
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

  def show
  end

end