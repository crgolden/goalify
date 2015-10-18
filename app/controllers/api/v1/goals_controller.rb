class Api::V1::GoalsController < Api::V1::ApiController
  acts_as_token_authentication_handler_for User, except: [:show, :index], fallback: :exception
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    @goals = Goal.accessible_by(current_ability).page(params[:page]).per(params[:per_page])
                 .filter(params.slice :user_id, :filter_title, :recent)
  end

  def show
    render :show, locals: {goal: @goal}, status: :ok, location: [:api, @goal]
  end

  def new
  end

  def edit
  end

  def create
    @goal.user = current_user
    if @goal.save
      render :show, locals: {goal: @goal}, status: :created, location: [:api, @goal]
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update goal_params
      render :show, locals: {goal: @goal}, status: :ok, location: [:api, @goal]
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy
    head 204
  end

  private

  def goal_params
    params.require(:goal).permit :title, :text, comments_attributes: [:id, :body]
  end

  def query_params
    params.permit :id, :user_id, :title, :text
  end

end
