class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]
  load_and_authorize_resource except: :create
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  
  def index
    users = User.all
    render json: users
  end

  def create 
      user = User.create!(user_params)
      @token = encode_token(user_id: user.id)
      render json: {
          user: UserSerializer.new(user), 
          token: @token
      }, status: :created
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:email].blank?
      render json: { error: "Email cannot be blank" }, status: :unprocessable_entity
    elsif @user.update(user_params)
      render json: @user
    else
      render json: { error: "Failed to update user" }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end
  
  def destroy
      user = User.find(params[:id])
      user.destroy
      render json: { message: 'User deleted' }, status: :no_content
  end

  def user_params 
      params.require(:user).permit(:email, :password, :first_name, :last_name, :age, :specialization,:role_id)
  end

  def handle_invalid_record(e)
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

end


