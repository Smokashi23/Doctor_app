class AuthsController < ApplicationController
    skip_before_action :authorized, only: [:login]
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  
    def login  
        @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            @token = encode_token(user_id: @user.id)
            render json: {
                user: UserSerializer.new(@user),
                token: @token
                }, status: :accepted
        else
            render json: {message: 'Incorrect password'}, status: :unauthorized
        end
    end
        
    def handle_record_not_found(e)
        render json: { message: "User doesn't exist" }, status: :unauthorized
    end 
end
  

