class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, except: [:show, :index]
  authorize_resource only: [:index, :show, :edit]
  load_and_authorize_resource only: [:new, :create, :update, :destroy]

  def index
    filter
  end

  def show
    load_user
  end

  def new
  end

  def edit
    load_user
  end

  def create
    @user.save ? create_success : create_errors
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
    destroy_success
  end

  private

  def user_params
    accessible = [:name, :email, :role, :status, :confirmed_at, :score, :password, :password_confirmation]
    params.require(:user).permit accessible
  end

end
