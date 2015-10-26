class CommentsController < ApplicationController
  include CommentsHelper
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    filter
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @comment.user = current_user
    @comment.save ? create_success : create_errors
  end

  def update
    @comment.update(comment_params) ? update_success : update_errors
  end

  def destroy
    @comment.destroy
    destroy_success
  end

  private

  def comment_params
    params.require(:comment).permit :goal_id, :user_id, :body
  end

end
