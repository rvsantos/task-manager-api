module Authenticable
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers[:Authorization])
  end

  def authenticate_with_token!
    unless user_logged_in?
      render json: { errors: 'Unauthorized access' }, status: :unauthorized
    end
  end

  def user_logged_in?
    current_user.present?
  end
end
