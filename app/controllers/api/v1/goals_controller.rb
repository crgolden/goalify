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
    @goals = init_goals
  end

  def show
    @goal = init_goal
  end

  def create
    if @goal.save
      render :show, status: :created, location: [:api, @goal]
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update goal_params
      render :show, status: :ok, location: [:api, @goal]
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy
    head 204
  end

  def comments
    @comments = Kaminari.paginate_array(init_comments).page(page_params[:page]).per page_params[:per_page]
  end

  def scores
    @scores = Kaminari.paginate_array(init_scores).page(page_params[:page]).per page_params[:per_page]
  end

  def search
    @goals = init_search
  end

  def subscribers
    @subscribers = Kaminari.paginate_array(init_subscribers).page(page_params[:page]).per page_params[:per_page]
  end

  private

  def goal_params
    params.require(:goal).permit :title, :text
  end

end
