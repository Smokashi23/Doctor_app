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
        JWT.decode(token, Rails.application.credentials[:secret_key_base])
      rescue JWT::DecodeError => e
        return "Unable to decode token: #{e.message}"
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
    if @user.nil?
      render json: { message: I18n.t('user.not_found') }, status: :not_found
    elsif current_user.nil?
      render json: { message: I18n.t('user.please_log_in') }, status: :unauthorized
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
  exception.default_message = "You are not authorized to perform this task"
  render json: { error: exception.message }, status: :forbidden
  end
end
  
