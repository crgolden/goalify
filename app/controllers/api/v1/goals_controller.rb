class Api::V1::GoalsController < Api::V1::ApiController
  load_and_authorize_resource

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
    @goal.user = current_user
    if @goal.save
      render :show, status: :created, location: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update goal_params
      render :show, status: :ok, location: @goal
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
    params.require(:goal).permit :title, :text
  end

  def query_params
    params.permit :id, :user_id, :title
  end

end
