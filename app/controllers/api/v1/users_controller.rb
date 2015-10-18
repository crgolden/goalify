class Api::V1::UsersController < Api::V1::ApiController
  include Api::V1::UsersHelper
  acts_as_token_authentication_handler_for User, except: [:show, :index], fallback: :exception
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    @users = User.accessible_by(current_ability).search(query_params)
                 .page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @user.save
      render :show, status: :created, location: [:api, @user]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    check_password
    if needs_password?
      @user.update(user_params) ? update_success : update_errors
    else
      @user.update_without_password(user_params) ? update_success : update_errors
    end
  end

  def destroy
    @user.soft_delete
    head 204
  end

  private

  def user_params
    accessible = [:name, :email, :role]
    accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit accessible
  end

  def query_params
    params.permit :id, :email, :name
  end

end
