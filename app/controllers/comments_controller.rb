class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource :goal
  load_and_authorize_resource :comment, through: :goal, shallow: true
  caches_action :new, :edit, :index, :show

  def index
    @comments = @goal.comments.accessible_by(current_ability)
                    .page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @comment = @goal.comments.create(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = 'Comment successfully created.'
      render :show
    else
      flash[:error] = 'There was a problem creating the comment.'
      redirect_to @comment.goal
    end
  end

  def update
    if @comment.update(comment_params)
      flash[:success] = 'Comment was successfully updated.'
      redirect_to @comment.goal
    else
      flash[:error] = 'There was a problem updating the comment.'
      render :edit
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'Comment was successfully deleted.'
    redirect_to @comment.goal
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def query_params
    params.permit(:id, :user_id, :goal_id, :body,)
  end

end
