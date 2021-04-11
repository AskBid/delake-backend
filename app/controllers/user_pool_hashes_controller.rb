class UserPoolHashesController < ApplicationController

  def create
  end  

  def index
  	user = User.find_by({username: params[:user_username]})
  	if user
  		pool_hashes = user.pool_hashes
  		epoch_stake = EpochStake.find(params[epoch_stake_id])
  	end
    binding.pry
  end

end