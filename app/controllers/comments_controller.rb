class CommentsController < ApplicationController

  include ActionView::Helpers::TextHelper

  before_action :authenticate_user!

  authorize_resource only: :create
  load_and_authorize_resource only: :destroy

  def create
    @comment = Goal.find(comment_params[:goal_id]).comments.build comment_params
    if @comment.save
      flash[:notice] = I18n.t 'comments.create.success'
      redirect_to comments_goal_path @comment.goal
    else
      flash.now[:error] = I18n.t 'comments.errors', count: pluralize(@comment.errors.count, 'error')
      render 'goals/show', goal: @comment.goal
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = I18n.t 'comments.destroy.success'
    redirect_to comments_goal_path @comment.goal
  end

  private

  def comment_params
    params.require(:comment).permit :goal_id, :user_id, :body
  end

end
