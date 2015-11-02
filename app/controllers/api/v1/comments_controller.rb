class Api::V1::CommentsController < Api::V1::ApiController

  acts_as_token_authentication_handler_for User, only: [:create, :destroy], fallback: :exception

  before_action :authenticate_user!

  authorize_resource :comment, only: :create
  load_and_authorize_resource :comment, only: :destroy

  wrap_parameters :comment, format: :json

  def create
    @goal = Goal.find params[:goal_id]
    @comment = @goal.comments.build comment_params
    if @comment.save
      @comments = Kaminari.paginate_array(@goal.comments).page(page_params[:page]).per page_params[:per_page]
      render 'api/v1/goals/comments.json.jbuilder', status: :created, location: comments_api_goal_path(@goal)
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head 204
  end

  private

  def comment_params
    params.permit :body, :goal_id, :user_id
  end

end
