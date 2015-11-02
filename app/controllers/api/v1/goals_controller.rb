class Api::V1::GoalsController < Api::V1::ApiController

  acts_as_token_authentication_handler_for User, only: [:create, :update, :destroy], fallback: :exception

  before_action :authenticate_user!, only: [:create, :update, :destroy]

  authorize_resource only: [:index, :show, :comments, :scores, :search, :subscribers]
  load_and_authorize_resource only: [:update, :destroy]
  load_and_authorize_resource only: [:create], through: :current_user

  caches_page :index, :show, :comments, :scores, :search, :subscribers
  caches_action :new, :edit

  wrap_parameters :goal, format: :json

  def index
    @goals = Goal.includes(:user, :comments, :subscribers)
                 .accessible_by(current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def show
    @goal = Goal.includes(:user, :comments, :subscribers).find params[:id]
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
    @goal = Goal.includes(:user, :subscribers, comments: :user).find params[:id]
    @comments = @goal.comments.includes(:user).page(page_params[:page]).per page_params[:per_page]
  end

  def scores
    @goal = Goal.includes(:user, :comments, :subscribers, scores: :user).find params[:id]
    @scores = @goal.scores.includes(:user).page(page_params[:page]).per page_params[:per_page]
  end

  def search
    @goals = Goal.includes(:user, :comments, :subscribers)
                 .accessible_by(current_ability).page(page_params[:page]).per(page_params[:per_page])
                 .search_title_and_text query_params[:q]
  end

  def subscribers
    @goal = Goal.includes(:user, :comments, subscribers: [:comments, :goals, :subscriptions, :tokens]).find(params[:id])
    @subscribers = @goal.subscribers.includes(:comments, :goals, :subscriptions, :tokens).page(page_params[:page]).per page_params[:per_page]
  end

  private

  def goal_params
    params.require(:goal).permit :title, :text
  end

end
