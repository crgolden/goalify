module Api::V1::UsersHelper

  protected

  def update_success
    render :show, status: :ok, location: [:api, @user]
  end

  def update_errors
    render json: @user.errors, status: :unprocessable_entity
  end

  def check_password
    false unless user_params[:password].blank?
    user_params.delete :password
    user_params.delete :password_confirmation
  end

  def needs_password?
    user_params[:password].present? || user_params[:password_confirmation].present?
  end

end
