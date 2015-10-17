class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    @users = User.accessible_by(current_ability).page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @user.save
      if @user.confirmed_at.present?
        flash[:success] = I18n.t 'users.create.confirmed_success'
      else
        flash[:notice] = I18n.t 'users.create.unconfirmed_success'
      end
      redirect_to @user
    else
      flash[:error] = I18n.t 'users.create.errors'
      render :new
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
    flash[:success] = I18n.t 'users.destroy.success'
    redirect_to users_path
  end

  private

  def user_params
    accessible = [:name, :email, :role, :status, :confirmed_at]
    accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

  # def query_params
  #   params.permit(:id, :email, :name)
  # end

end
