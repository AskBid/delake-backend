class UserPoolHashSerializer
  def initialize(user_pool_hashes=[])
  	@user_pool_hashes = user_pool_hashes
  end

  def to_compared_epoch_stakes(epoch_stake)
	  @user_pool_hashes.map do |user_pool_hash|
	  	pool_hash = user_pool_hash.pool_hash
	    any_pool_epoch_stake = pool_hash.epoch_stakes.epoch(epoch_stake.epoch_no).first
	    pool = pool_hash.pool
	    compared_epoch_stake = {
	    	id: epoch_stake.id,
	    	user_pool_hash_id: user_pool_hash.id,
	      calc_rewards: epoch_stake.calc_rewards(pool_hash),
	      amount: epoch_stake.amount,
	      stake_address: {id: epoch_stake.stake_address.id}
	    }
	    if any_pool_epoch_stake
	      compared_epoch_stake[:blocks] = any_pool_epoch_stake.blocks
	      compared_epoch_stake[:estimated_blocks] = any_pool_epoch_stake.estimated_blocks
	    else
	      compared_epoch_stake[:blocks] = 0
	      compared_epoch_stake[:estimated_blocks] = 0
	    end
	    if pool
	      compared_epoch_stake[:pool_hash] = {
	        pool: {ticker: pool.ticker},
	        id: pool_hash.id,
	        size: pool_hash.size(epoch_stake.epoch_no)
	      }
	    else
	      compared_epoch_stake[:pool_hash] = {
	        pool: {ticker: '---'},
	        id: pool_hash.id
	      }
	    end
	    compared_epoch_stake
	  end
	end

end