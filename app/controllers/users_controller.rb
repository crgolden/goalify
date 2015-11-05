class UsersController < ApplicationController

  include ActionView::Helpers::TextHelper
  include UsersHelper

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  authorize_resource only: [:index, :show, :edit, :comments, :goals, :search, :scores, :subscriptions, :tokens]
  load_and_authorize_resource only: [:new, :create, :update, :destroy]

  caches_page :index, :show, :comments, :goals, :scores, :search, :subscriptions, :tokens
  caches_action :new, :edit

  def index
    init_users
  end

  def show
    init_user
  end

  def new
  end

  def edit
    init_user
  end

  def create
    if @user.save
      if @user.confirmed_at.present?
        flash[:notice] = I18n.t('users.create.confirmed_success')
      else
        flash[:notice] = I18n.t('users.create.unconfirmed_success')
      end
      redirect_to @user
    else
      flash.now[:error] = I18n.t 'users.errors', count: pluralize(@user.errors.count, 'error')
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
    flash[:notice] = I18n.t 'users.update.confirmed_success'
    redirect_to @user
  end

  def comments
    init_comments
  end

  def goals
    init_goals
  end

  def search
    @users = init_users.search_name query_params[:q]
  end

  def scores
    init_scores
  end

  def subscriptions
    init_subscriptions
  end

  def tokens
    init_tokens
  end

  protected

  def update_success
    if @user.unconfirmed_email.present?
      flash[:notice] = I18n.t 'users.update.unconfirmed_success'
    else
      flash[:notice] = I18n.t 'users.update.confirmed_success'
    end
    redirect_to @user
  end

  def update_errors
    flash.now[:error] = I18n.t 'users.errors', count: pluralize(@user.errors.count, 'error')
    render :edit
  end

  private

  def user_params
    accessible = [:name, :email, :role, :status, :confirmed_at]
    accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

end
