class GoalsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  authorize_resource only: [:index, :show, :edit, :comments, :scores, :search, :subscribers]
  load_and_authorize_resource only: [:update, :destroy]
  load_and_authorize_resource only: [:new, :create], through: :current_user

  caches_page :index, :show, :comments, :scores, :search, :subscribers
  caches_action :new, :edit

  def index
    @goals = Goal.includes(:user, :comments, :subscribers)
                 .accessible_by(current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def show
    @goal = Goal.includes(:user, :comments, :subscribers).find params[:id]
  end

  def new
  end

  def edit
    @goal = Goal.includes(:user, :comments, :subscribers).find params[:id]
  end

  def create
    if @goal.save
      flash[:success] = I18n.t 'goals.create.success'
      redirect_to @goal
    else
      flash.now[:error] = I18n.t 'goals.create.errors'
      render :new
    end
  end

  def update
    if @goal.update goal_params
      flash[:success] = I18n.t 'goals.update.success'
      redirect_to @goal
    else
      flash.now[:error] = I18n.t 'goals.update.errors'
      render :edit
    end
  end

  def destroy
    @goal.destroy
    flash[:success] = I18n.t 'goals.destroy.success'
    redirect_to goals_path
  end

  def comments
    @goal = Goal.includes(:user, :subscribers, comments: :user).find params[:id]
    @comments = @goal.comments.includes(:user).page(page_params[:page]).per page_params[:per_page]
  end

  def scores
    @goal = Goal.includes(:user, :comments, :subscribers, scores: :user).find params[:id]
    @scores = @goal.scores.includes(:user).page(page_params[:page]).per page_params[:per_page]
  end

  def search
    @goals = Goal.includes(:user, :comments, :subscribers)
                 .accessible_by(current_ability).page(page_params[:page]).per(page_params[:per_page])
                 .search_title_and_text query_params[:q]
  end

  def subscribers
    @goal = Goal.includes(:user, :comments, subscribers: [:comments, :goals, :subscriptions, :tokens]).find(params[:id])
    @subscribers = @goal.subscribers.includes(:comments, :goals, :subscriptions, :tokens).page(page_params[:page]).per page_params[:per_page]
  end

  private

  def goal_params
    params.require(:goal).permit :title, :text, :user_id
  end

end
