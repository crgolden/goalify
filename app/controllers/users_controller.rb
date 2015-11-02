class UsersController < ApplicationController

  include UsersHelper

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  authorize_resource only: [:index, :show, :edit, :comments, :goals, :search, :scores, :subscriptions, :tokens]
  load_and_authorize_resource only: [:new, :create, :update, :destroy]

  caches_page :index, :show, :comments, :goals, :scores, :search, :subscriptions, :tokens
  caches_action :new, :edit

  def index
    @users = init_users
  end

  def show
    @user = init_user
  end

  def new
  end

  def edit
    @user = init_user
  end

  def create
    if @user.save
      if @user.confirmed_at.present?
        flash[:success] = I18n.t('users.create.confirmed_success')
      else
        flash[:notice] = I18n.t('users.create.unconfirmed_success')
      end
      redirect_to @user
    else
      flash.now[:error] = I18n.t 'users.create.errors'
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
    flash[:success] = I18n.t 'users.update.confirmed_success'
    redirect_to @user
  end

  def comments
    @comments = Kaminari.paginate_array(init_comments).page(page_params[:page]).per page_params[:per_page]
  end

  def goals
    @goals = Kaminari.paginate_array(init_goals).page(page_params[:page]).per page_params[:per_page]
  end

  def search
    @users = init_search
  end

  def scores
    @scores = Kaminari.paginate_array(init_scores).page(page_params[:page]).per page_params[:per_page]
  end

  def subscriptions
    @subscriptions = Kaminari.paginate_array(init_subscriptions).page(page_params[:page]).per page_params[:per_page]
  end

  def tokens
    @tokens = Kaminari.paginate_array(init_tokens).page(page_params[:page]).per page_params[:per_page]
  end

  protected

  def update_errors
    flash[:error] = I18n.t 'users.update.errors'
    render :edit
  end

  def update_success
    update_current_user
    @user.unconfirmed_email.present? ? flash[:notice] = I18n.t('users.update.unconfirmed_success') : flash[:success] = I18n.t('users.update.confirmed_success')
    redirect_to @user
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :role, :status, :confirmed_at, :password, :password_confirmation
  end

end
