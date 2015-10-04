module UsersHelper
  def create_success
    flash[:success] = 'User successfully created.'
    redirect_to @user
  end

  def create_errors
    flash[:error] = 'There was a problem creating the user.'
    render :new
  end

  def update_success
    sign_in(@user == current_user ? @user : current_user, bypass: true)
    flash[:success] = 'User was successfully updated.'
    redirect_to @user
  end

  def update_errors
    sign_in(@user == current_user ? @user : current_user, bypass: true)
    flash[:error] = 'There was a problem updating the user.'
    render :edit
  end

  def destroy_success
    flash[:success] = 'User was successfully deleted.'
    redirect_to users_path
  end

  protected

  def check_password
    false unless user_params[:password].blank?
    user_params.delete :password
    user_params.delete :password_confirmation
  end

  def needs_password?
    user_params[:password].present? || user_params[:password_confirmation].present?
  end
end
