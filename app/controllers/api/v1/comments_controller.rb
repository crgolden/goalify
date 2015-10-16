class Api::V1::CommentsController < Api::V1::ApiController
  load_and_authorize_resource :goal
  load_and_authorize_resource :comment, through: :goal, shallow: true

  def index
    @comments = @goal.comments.accessible_by(current_ability).page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @comment = @goal.comments.create comment_params
    @comment.user = current_user
    if @comment.save
      render :show, status: :created, location: [:api, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update comment_params
      render :show, status: :ok, location: [:api, @comment]
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
    params.require(:comment).permit :body
  end

  # def query_params
  #   params.permit(:id, :user_id, :goal_id, :body,)
  # end

end
