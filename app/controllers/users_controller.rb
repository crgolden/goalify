class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  authorize_resource except: [:index, :show, :edit, :comments, :goals, :search, :scores, :subscriptions, :tokens]
  load_and_authorize_resource only: [:new, :create, :update, :destroy]

  caches_page :index, :show, :comments, :goals, :scores, :search, :subscriptions, :tokens
  caches_action :new, :edit

  def index
    @users = User.includes(:comments, :goals, :subscriptions, :tokens)
                 .accessible_by(current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def show
    @user = User.includes(:comments, :goals, :subscriptions, :tokens).find params[:id]
  end

  def new
  end

  def edit
    @user = User.includes(:comments, :goals, :subscriptions, :tokens).find params[:id]
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
      @user.update(user_params) ? update_success(@user) : update_errors
    else
      @user.update_without_password(user_params) ? update_success(@user) : update_errors
    end
  end

  def destroy
    @user.soft_delete
    flash[:success] = I18n.t 'users.update.confirmed_success'
    redirect_to @user
  end

  def comments
    @user = User.includes(:goals, :subscriptions, :tokens, comments: :goal).find params[:id]
    @comments = @user.comments.includes(:goal).page(page_params[:page]).per page_params[:per_page]
  end

  def goals
    @user = User.includes(:comments, :subscriptions, :tokens, goals: [:comments, :subscribers]).find params[:id]
    @goals = @user.goals.includes(:comments, :subscribers).page(page_params[:page]).per page_params[:per_page]
  end

  def search
    @users = User.includes(:comments, :goals, :subscriptions, :tokens)
                 .accessible_by(current_ability).page(page_params[:page]).per(page_params[:per_page])
                 .search_name query_params[:q]
  end

  def scores
    @user = User.includes(:comments, :goals, :subscriptions, :tokens, scores: :goal).find params[:id]
    @scores = @user.scores.includes(:goal).page(page_params[:page]).per page_params[:per_page]
  end

  def subscriptions
    @user = User.includes(:comments, :goals, :tokens, subscriptions: [:user, :comments, :subscribers]).find params[:id]
    @subscriptions = @user.subscriptions.includes(:user, :comments, :subscribers).page(page_params[:page]).per page_params[:per_page]
  end

  def tokens
    @user = User.includes(:comments, :goals, :subscriptions, :tokens).find params[:id]
    @tokens = @user.tokens.page(page_params[:page]).per page_params[:per_page]
    authorize! :tokens, @user
  end

  protected

  def check_password
    false unless user_params[:password].blank?
    user_params.delete [:password, :password_confirmation]
  end

  def needs_password?
    user_params[:password].present? || user_params[:password_confirmation].present?
  end

  def update_success(user)
    if user == current_user
      @current_ability = nil
      @current_user = nil
    end
    user.unconfirmed_email.present? ? flash[:notice] = I18n.t('users.update.unconfirmed_success') : flash[:success] = I18n.t('users.update.confirmed_success')
    redirect_to user
  end

  def update_errors
    flash.now[:error] = I18n.t 'users.update.errors'
    render :edit
  end

  private

  def user_params
    accessible = [:name, :email, :role, :status, :confirmed_at, :password]
    params.require(:user).permit accessible
  end

end
