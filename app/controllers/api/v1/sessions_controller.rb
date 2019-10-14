class Api::V1::SessionsController < ApplicationController
  def create
    @user = User.find_by(email: session_params[:email])

    if @user&.valid_password?(session_params[:password])
      sign_in @user, store: false
      @user.generate_auth_token!
      @user.save
      render json: @user, status: :ok
    else
      render json: { errors: 'Invalid password or email' }, status: :unauthorized
    end
  end

  def destroy
    @user = User.find_by(auth_token: params[:id])
    @user.generate_auth_token!
    @user.save
    head 204
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
