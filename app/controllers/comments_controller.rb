class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
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
    @comment = @goal.comments.new comment_params
    @comment.user = current_user
    if @comment.save
      flash[:success] = I18n.t 'comments.create.success'
      redirect_to @comment
    else
      flash[:error] = I18n.t 'comments.create.errors'
      redirect_to @comment.goal
    end
  end

  def update
    if @comment.update(comment_params)
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
    redirect_to @comment.goal
  end

  private

  def comment_params
    params.require(:comment).permit :body
  end

  # def query_params
  #   params.permit(:id, :user_id, :goal_id, :body,)
  # end

end
