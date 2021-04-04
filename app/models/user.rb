class User < ApplicationRecord
	has_secure_password

	has_many :user_stakes
	# below association wouldn't work because of the tables being in to different databases
	# has_many :stake_addresses, through: :user_stakes
	validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }
	validates :username, presence: true, uniqueness: true, length: {maximum: 10}
  validates :password, length: {maximum: 12}
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: lambda { self.email.blank? }
  before_save :downcase_name

  def stake_addresses
  	StakeAddress.by_user(self)
 	end

 	def stake_address=(stake_address)
 		UserStake.create(user_id: self.id, stake_address_id: stake_address.id)
 	end

 	def delete_stake_address(stake_address)
 		user_stake = UserStake.find(user_id: self.id, stake_address_id: stake_address.id)
 		user_stake.delete
 	end
end
