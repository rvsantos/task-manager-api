class Api::V1::UsersController < ApplicationController
  respond_to :json

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    respond_with(@user)
  rescue ActiveRecord::RecordNotFound
    head 404
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
