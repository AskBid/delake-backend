class UserPoolHashesController < ApplicationController

  def create
  end  

  def index
  	user = User.find_by({username: params[:user_username]})
  	if user
  		pool_hashes = user.pool_hashes
  		epoch_stake = EpochStake.find(params[:epoch_stake_id])
      @compared_epoch_stakes = pool_hashes.map do |pool_hash|
        random_pool_epoch_stake = pool_hash.epoch_stakes.epoch(epoch_stake.epoch_no).first
        pool = pool_hash.pool
        compared_epoch_stake = {
          calc_rewards: epoch_stake.calc_rewards(pool_hash),
          amount: epoch_stake.amount,
          stake_address: {id: epoch_stake.stake_address.id}
        }
        if random_pool_epoch_stake
          compared_epoch_stake[:blocks] = random_pool_epoch_stake.blocks
          compared_epoch_stake[:estimated_blocks] = random_pool_epoch_stake.estimated_blocks
        else
          compared_epoch_stake[:blocks] = 0
          compared_epoch_stake[:estimated_blocks] = 0
        end
        if pool
          compared_epoch_stake[:pool_hash] = {
            pool: {ticker: pool.ticker},
            id: pool_hash.id
          }
        else
          compared_epoch_stake[:pool_hash] = {
            pool: {ticker: '---'},
            id: pool_hash.id
          }
        end
        compared_epoch_stake
      end
      render json: @compared_epoch_stakes, status: :ok
  	else
      render status: :not_found
    end
  end

end