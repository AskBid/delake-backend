class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: session_params[:username])
    if @user && @user.authenticate(session_params[:password])
    	@token = encode_token(user_id: @user.id)
      render json: {
      	username: @user.username,
      	user_id: @user.id,
      	jwt: @token
      }, status: :created
    else
      render json: { errors: "Username and/or password were wrong." }, status: :not_acceptable
    end
  end

  private

  def session_params
  	params.require(:session).permit(:username, :password)
  end
end