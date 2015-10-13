class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource
  caches_page :index, :show
  caches_action :new, :edit

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
        flash[:success] = I18n.t 'devise.registrations.signed_up'
      else
        flash[:notice] = I18n.t 'devise.registrations.signed_up_but_unconfirmed'
      end
      render :show
    else
      flash[:error] = 'There was a problem creating the user.'
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
    flash[:success] = I18n.t 'devise.registrations.destroyed'
    redirect_to users_path
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
