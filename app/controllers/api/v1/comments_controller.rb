class Api::V1::CommentsController < Api::V1::ApiController
  load_resource :goal
  load_resource :comment, through: :goal, shallow: true

  def index
  end

  def show
  end

  def create
    if user_signed_in?
      @comment = @goal.comments.create(comment_params)
      @comment.user = current_user
      if @comment.save
        render :show, status: :created, location: [:api, @comment]
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if user_signed_in? && (current_user.admin? || (current_user == @comment.user))
      if @comment.update(comment_params)
        render :show, status: :ok, location: [:api, @comment]
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if user_signed_in? && (current_user.admin? || (current_user == @comment.user))
      @comment.destroy
      head 204
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end