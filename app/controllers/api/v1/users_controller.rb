class Api::V1::UsersController < Api::V1::ApiController

  include UsersHelper

  acts_as_token_authentication_handler_for User, only: [:create, :update, :destroy, :tokens], fallback: :exception

  before_action :authenticate_user!, only: [:create, :update, :destroy]

  authorize_resource only: [:index, :show, :comments, :goals, :search, :scores, :subscriptions, :tokens]
  load_and_authorize_resource only: [:create, :update, :destroy]

  caches_page :index, :show, :comments, :goals, :scores, :search, :subscriptions, :tokens

  wrap_parameters :user, format: :json

  def index
    init_users
  end

  def show
    init_user
  end

  def create
    if @user.save
      render :show, status: :created, location: [:api, @user], formats: :json
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
    render :show, status: :ok, location: [:api, @user], formats: :json
  end

  def update_errors
    render json: @user.errors, status: :unprocessable_entity
  end

  private

  def user_params
    accessible = [:name, :email, :role]
    accessible << [:password, :password_confirmation] unless params[:password].blank?
    params.permit accessible
  end

end
