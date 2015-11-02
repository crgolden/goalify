class Api::V1::UsersController < Api::V1::ApiController

  include UsersHelper

  acts_as_token_authentication_handler_for User, only: [:create, :update, :destroy, :tokens], fallback: :exception

  before_action :authenticate_user!, only: [:create, :update, :destroy]

  authorize_resource only: [:index, :show, :comments, :goals, :search, :scores, :subscriptions, :tokens]
  load_and_authorize_resource only: [:create, :update, :destroy]

  caches_page :index, :show, :comments, :goals, :scores, :search, :subscriptions, :tokens

  wrap_parameters :user, format: :json

  def index
    @users = init_users
  end

  def show
    @user = init_user
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
    end
  else
    @user.update_without_password(user_params) ? update_success : update_errors
  end

  def destroy
    @user.soft_delete
    head 204
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
    render json: @user.errors, status: :unprocessable_entity
  end

  def update_success
    update_current_user
    render :show, status: :ok, location: [:api, @user]
  end

  private

  def user_params
    params.permit :name, :email, :role, :status, :confirmed_at, :password, :password_confirmation
  end

end
