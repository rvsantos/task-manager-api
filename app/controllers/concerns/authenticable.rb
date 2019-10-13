module Authenticable
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers[:Authorization])
  end

  def authenticate_with_token!
    if current_user.blank?
      render json: { errors: 'Unauthorized access' }, status: :unauthorized
    end
  end
end
