module UsersHelper

  protected

  def update_success
    if @user.unconfirmed_email.present?
      flash[:notice] = I18n.t 'users.update.unconfirmed_success'
    else
      flash[:success] = I18n.t 'users.update.confirmed_success'
    end
    redirect_to @user
  end

  def update_errors
    flash[:error] = I18n.t 'users.update.errors'
    render :edit
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
