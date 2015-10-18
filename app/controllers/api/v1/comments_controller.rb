class Api::V1::CommentsController < Api::V1::ApiController
  acts_as_token_authentication_handler_for User, except: [:show, :index], fallback: :exception
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    @comments = Comment.accessible_by(current_ability).search(query_params)
                    .page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
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
    params.require(:comment).permit :body, :goal_id, :user_id
  end

  def query_params
    params.permit :id, :user_id, :goal_id, :body
  end

end
