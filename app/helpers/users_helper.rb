module UsersHelper
  def create_success
    flash[:success] = 'User successfully created'
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render :show, status: :created, user: @user }
    end
  end

  def create_errors
    flash[:error] = 'There was a problem creating the user'
    respond_to do |format|
      format.html { render :new }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  def update_success
    sign_in(@user == current_user ? @user : current_user, bypass: true)
    flash[:success] = 'User was successfully updated.'
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render :show, status: :ok, user: @user }
    end
  end

  def update_errors
    sign_in(@user == current_user ? @user : current_user, bypass: true)
    flash[:error] = 'There was a problem updating the user.'
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  def destroy_success
    flash[:success] = 'User was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to users_path }
      format.json { head :no_content }
    end
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
