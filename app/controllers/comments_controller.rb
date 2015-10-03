class CommentsController < ApplicationController
  include CommentsHelper
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource :goal
  load_and_authorize_resource :comment, through: :goal, shallow: true

  def index
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
    @comment.save ? create_success : create_errors
  end

  def update
    @comment.update(comment_params) ? update_success : update_errors
  end

  def destroy
    destroy_success if @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
