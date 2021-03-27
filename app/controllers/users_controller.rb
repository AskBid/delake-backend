class UsersController < ApplicationController
	def create
		@user = User.create(user_params)
    if @user.valid?
      @token = encode_token(user_id: @user.id)
      render json: { alerts: {success: 'The user was registered successfully!'} }, status: :created
    else
      render json: { errors: @user.errors.messages }, status: :not_acceptable
    end
	end

  def show
    render json: { user: UserSerializer.new(User.new(username: 'sergio')), jwt:' @token' }, status: :created
  end

  private 

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end