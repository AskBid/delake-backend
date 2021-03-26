class User < ApplicationRecord
	has_secure_password

	has_many :user_stakes
	has_many :stake_addresses, through: :user_stakes

	validates :username, presence: true, uniqueness: true, length: {maximum: 10}
  validates :password, length: {maximum: 12}
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: lambda { self.email.blank? }
end
