class Api::V1::GoalsController < Api::V1::ApiController

  include GoalsHelper

  acts_as_token_authentication_handler_for User, only: [:create, :update, :destroy], fallback: :exception

  before_action :authenticate_user!, only: [:create, :update, :destroy]

  authorize_resource only: [:index, :show, :comments, :scores, :search, :subscribers]
  load_and_authorize_resource only: [:update, :destroy]
  load_and_authorize_resource only: [:create], through: :current_user

  caches_page :index, :show, :comments, :scores, :search, :subscribers

  wrap_parameters :goal, format: :json

  def index
    init_goals
  end

  def show
    init_goal
    @subscription = GoalsUsers.find_by(goal: @goal, user: current_user) if user_signed_in?
  end

  def create
    if @goal.save
      render :show, status: :created, location: [:api, @goal], formats: :json
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update goal_params
      render :show, status: :ok, location: [:api, @goal], formats: :json
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy
    head 204
  end

  def comments
    init_comments
  end

  def scores
    init_scores
  end

  def search
    @goals = init_goals.search_title_and_text query_params[:q]
  end

  def subscribers
    init_subscribers
  end

  private

  def goal_params
    params.permit :title, :text
  end

end
