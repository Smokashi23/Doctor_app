class ApplicationController < ActionController::API
    before_action :authorized
  
    def encode_token(payload)
      JWT.encode(payload, Rails.application.credentials[:secret_key_base])
    end
  
    def decoded_token
        header = request.headers['Authorization']
        if header
            token = header.split(" ")[1]
            begin
                JWT.decode(token, Rails.application.credentials[:secret_key_base] )
            rescue JWT::DecodeError
                nil
            end
        end
    end
  
    def current_user
      if decoded_token
          user_id = decoded_token[0]['user_id']
          @user = User.find_by(id: user_id)
      end
    end
  
    def authorized
      @user = User.find_by!(email: user_params[:email])
      if current_user.nil?
      render json: { message: 'Please log in' }, status: :unauthorized
      end
    end 
  end
  
