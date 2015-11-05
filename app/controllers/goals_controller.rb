class GoalsController < ApplicationController

  include ActionView::Helpers::TextHelper
  include GoalsHelper

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  authorize_resource only: [:index, :show, :edit, :comments, :scores, :search, :subscribers]
  load_and_authorize_resource only: [:update, :destroy]
  load_and_authorize_resource only: [:new, :create], through: :current_user

  caches_page :index, :show, :comments, :scores, :search, :subscribers
  caches_action :new, :edit

  def index
    init_goals
  end

  def show
    init_goal
    @subscription = GoalsUsers.find_by(goal: @goal, user: current_user) if user_signed_in?
  end

  def new
  end

  def edit
    init_goal
    @subscription = GoalsUsers.find_by(goal: @goal, user: current_user) if user_signed_in?
  end

  def create
    if @goal.save
      flash[:notice] = I18n.t 'goals.create.success'
      redirect_to @goal
    else
      flash.now[:notice] = I18n.t 'goals.errors', count: pluralize(@goal.errors.count, 'error')
      render :new
    end
  end

  def update
    if @goal.update goal_params
      flash[:notice] = I18n.t 'goals.update.success'
      redirect_to @goal
    else
      flash.now[:notice] = I18n.t 'goals.errors', count: pluralize(@goal.errors.count, 'error')
      render :edit
    end
  end

  def destroy
    @goal.destroy
    flash[:notice] = I18n.t 'goals.destroy.success'
    redirect_to goals_path
  end

  def comments
    init_comments
  end

  def scores
    init_scores
  end

  def search
    @goals = init_goals.search_title_and_text query_params[:q]
  end

  def subscribers
    init_subscribers
  end

  private

  def goal_params
    params.require(:goal).permit :title, :text, :user_id
  end

end
