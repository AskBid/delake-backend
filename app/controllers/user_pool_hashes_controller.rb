class UserPoolHashesController < ApplicationController

  def create
    user = User.find_by({username: params[:user_username]})
    authenticated = user === current_user
    if authenticated
      @pool = Pool.find_by(ticker: params[:ticker])
      if @pool
        pool_hash = @pool.pool_hash
      else
        pool_hash = HashPool.find_by(ticker: params[:ticker]) if params[:ticker].include?('pool1')
      end
      if pool_hash
        added = user.add_pool_hash(@pool_hash) if user
        if added || !user
          @epoch_stake = EpochStake.find_by(id: params[:epoch_stake_id])
          render json: UserPoolHashSerializer.new([@pool]).to_compared_epoch_stakes(@epoch_stake), status: :ok
        elsif user
          render json: {error: "Pool #{params[:ticker]} is already followed from #{params[:user_username]}."}, status: :not_acceptable
        end
      else
        render json: {error: "#{params[:ticker]} Pool not found. Try a different Pool/ticker."}, status: :not_found
      end
    else
      render json: {error: "#{current_user} cannot add a pool to #{params[:user_username]}"}, status: :unauthorized
    end
  end  

  def index
  	user = User.find_by({username: params[:user_username]})
  	if user
  		@user_pool_hashes = user.user_pool_hashes
  		@epoch_stake = EpochStake.find_by(id: params[:epoch_stake_id])

      render json: UserPoolHashSerializer.new(@user_pool_hashes).to_compared_epoch_stakes(@epoch_stake), status: :ok
  	else
      render status: :not_found
    end
  end

  def destroy
    user_pool_hash = UserPoolHash.find_by(id: params[:id])
    if user_pool_hash && user_pool_hash.user.id === current_user.id
      ticker = user_pool_hash.pool_hash.pool.ticker
      user_pool_hash.delete
      render json: {message: "#{ticker} pool has been deleted from your followed pools."}, status: :ok
    else
      render json: {error: "#{ticker} pool has been deleted from your followed pools."}, status: :unauthorized
    end
  end

end

