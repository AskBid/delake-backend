class User < ApplicationRecord
	has_secure_password

	has_many :user_stakes
	has_many :user_pool_hashes
	# has_many :pool_hashes, through: :user_pool_hashes
	# below association wouldn't work because of the tables being in to different databases
	# has_many :stake_addresses, through: :user_stakes
	validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }
	validates :username, presence: true, uniqueness: true, length: {maximum: 10}
  validates :password, length: {maximum: 12}
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: lambda { self.email.blank? }
  before_save :downcase_username

  def pool_hashes
  	PoolHash.by_user(self)
  end

  def add_pool_hash(pool_hash)
  	user_pool_hash = UserPoolHash.new(user_id: self.id, pool_hash_id: pool_hash.id)
 		user_pool_hash.save
  end

  def stake_addresses
  	StakeAddress.by_user(self)
 	end

 	def add_stake_address(stake_address)
 		user_stake = UserStake.new(user_id: self.id, stake_address_id: stake_address.id)
 		user_stake.save
 	end

 	def delete_stake_address(stake_address)
 		user_stake = UserStake.find(user_id: self.id, stake_address_id: stake_address.id)
 		user_stake.delete
 	end

  def downcase_username
    self.username.downcase
  end
end
