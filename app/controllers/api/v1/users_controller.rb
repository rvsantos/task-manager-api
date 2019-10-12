class Api::V1::UsersController < ApplicationController
  before_action :find_user, only: %i[destroy show update]
  respond_to :json

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    respond_with(@user)
  end

  def destroy
    @user.destroy
    head 204
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head 404
  end
end
