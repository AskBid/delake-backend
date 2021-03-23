class User < ApplicationRecord
	has_secure_password

	has_many :user_stakes
	has_many :stake_addresses, through: :user_stakes
end
