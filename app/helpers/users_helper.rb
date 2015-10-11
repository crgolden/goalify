module UsersHelper

  def update_success
    if @user.unconfirmed_email.present?
      flash[:notice] = I18n.t 'devise.registrations.update_needs_confirmation'
    else
      flash[:success] = I18n.t 'devise.registrations.updated'
    end
    redirect_to @user
  end

  def update_errors
    flash[:error] = 'There was a problem updating the user.'
    render :edit
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
