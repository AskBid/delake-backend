class UserStakeController < ApplicationController
	def create
		user = User.find_by({username: params[:user_username]})
		binding.pry
	end
end