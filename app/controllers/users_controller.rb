class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
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
    accessible = [:name, :email]
    accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

end
