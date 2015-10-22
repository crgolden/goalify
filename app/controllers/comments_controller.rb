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
    if @comment.save
      flash[:success] = I18n.t 'comments.create.success'
      redirect_to comments_path(goal_id: @comment.goal_id)
    else
      flash[:error] = I18n.t 'comments.create.errors'
      redirect_to @comment.goal
    end
  end

  def update
    if @comment.update comment_params
      flash[:success] = I18n.t 'comments.update.success'
      redirect_to @comment
    else
      flash[:error] = I18n.t 'comments.update.errors'
      render :edit
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = I18n.t 'comments.destroy.success'
    session[:referrer] ? redirect_to(session[:referrer]) : redirect_to(:back)
  end

  private

  def comment_params
    params.require(:comment).permit :goal_id, :user_id, :body
  end

end
