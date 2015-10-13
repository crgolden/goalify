class Api::V1::UsersController < Api::V1::ApiController
  include Api::V1::UsersHelper
  load_resource
  caches_action :new, :edit, :index, :show

  def index
    @users = User.accessible_by(current_ability).page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def create
    if user_signed_in? && current_user.admin?
      if @user.save
        render :show, status: :created, location: [:api, @user]
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if user_signed_in? && (current_user.admin? || (current_user == @user))
      check_password
      if needs_password?
        @user.update(user_params) ? update_success : update_errors
      else
        @user.update_without_password(user_params) ? update_success : update_errors
      end
    end
  end

  def destroy
    if user_signed_in? && (current_user.admin? || (current_user == @user))
      @user.soft_delete
      head 204
    end
  end

  private

  def user_params
    accessible = [:name, :email, :role]
    accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

  # def query_params
  #   params.permit(:id, :email, :name)
  # end

end
