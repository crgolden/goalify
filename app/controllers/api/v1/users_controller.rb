class Api::V1::UsersController < Api::V1::ApiController

  acts_as_token_authentication_handler_for User, only: [:create, :update, :destroy, :tokens], fallback: :exception

  before_action :authenticate_user!, only: [:create, :update, :destroy]

  authorize_resource only: [:index, :show, :comments, :goals, :search, :scores, :subscriptions, :tokens]
  load_and_authorize_resource only: [:create, :update, :destroy]

  caches_page :index, :show, :comments, :goals, :scores, :search, :subscriptions, :tokens

  wrap_parameters :user, format: :json

  def index
    @users = User.includes(:comments, :goals, :subscriptions, :tokens).accessible_by(current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def show
    @user = User.includes(:comments, :goals, :subscriptions, :tokens).find params[:id]
  end

  def create
    if @user.save
      render 'api/v1/users/show.json.jbuilder', status: :created, location: [:api, @user]
    else
      render json: @user.errors, status: :unprocessable_entity
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
    head 204
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

  def update_success(user)
    if user == current_user
      @current_ability = nil
      @current_user = nil
    end
    render 'api/v1/users/show.json.jbuilder', status: :ok, location: [:api, user]
  end

  def update_errors
    render json: @user.errors, status: :unprocessable_entity
  end

  def check_password
    false unless user_params[:password].blank?
    user_params.delete :password
    user_params.delete :password_confirmation
  end

  def needs_password?
    user_params[:password].present? || user_params[:password_confirmation].present?
  end

  private

  def user_params
    accessible = [:name, :email, :role]
    accessible << [:password, :password_confirmation] unless params[:password].blank?
    params.permit accessible
  end

end
