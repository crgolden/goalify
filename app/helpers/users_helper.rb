module UsersHelper

  protected

  def filter
    @users = User.accessible_by(current_ability).order(score: :desc).page(params[:page]).per(params[:per_page])
  end

  def load_user
    @user = User.includes(:comments, :goals, :subscriptions, :tokens).find params[:id]
  end

  def create_success
    @user.confirmed_at.present? ? flash[:success] = I18n.t('users.create.confirmed_success') : flash[:notice] = I18n.t('users.create.unconfirmed_success')
    redirect_to @user
  end

  def create_errors
    flash[:error] = I18n.t('users.create.errors')
    render :new
  end

  def update_success
    @user.unconfirmed_email.present? ? flash[:notice] = I18n.t('users.update.unconfirmed_success') : flash[:success] = I18n.t('users.update.confirmed_success')
    redirect_to @user
  end

  def update_errors
    flash[:error] = I18n.t('users.update.errors')
    render :edit
  end

  def destroy_success
    flash[:success] = I18n.t('users.update.confirmed_success')
    redirect_to @user
  end

  def check_password
    false unless user_params[:password].blank?
    user_params.delete [:password, :password_confirmation]
  end

  def needs_password?
    user_params[:password].present? || user_params[:password_confirmation].present?
  end

end
