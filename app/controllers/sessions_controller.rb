class SessionsController < ApplicationController
  def create
    user = User.find_by(name: session_params[:name])
    if user && user.authenticate(session_params[:password])
      render json: {username: @user.username, jwt: @token}, status: :created
    else
      
    end
  end


end