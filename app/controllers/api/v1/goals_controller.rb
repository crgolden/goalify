class Api::V1::GoalsController < Api::V1::ApiController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_resource except: :index
  caches_page :index, :show
  caches_action :new, :edit

  def index
    @goals = Goal.accessible_by(current_ability).search(query_params).page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if user_signed_in?
      @goal.user = current_user
      if @goal.save
        render :show, status: :created, location: @goal
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if user_signed_in? && (current_user.admin? || (current_user == @goal.user))
      if @goal.update(goal_params)
        render :show, status: :ok, location: @goal
      else
        render json: @goal.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if user_signed_in? && current_user.admin?
      @goal.destroy
      head 204
    else
      head 403
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :text)
  end

  def query_params
    params.permit(:id, :user_id, :title)
  end

end
