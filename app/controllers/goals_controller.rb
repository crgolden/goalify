class GoalsController < ApplicationController
  include GoalsHelper
  before_action :authenticate_user!, except: [:show, :index, :search]
  authorize_resource only: [:index, :search, :show, :edit]
  load_and_authorize_resource only: [:new, :create, :update, :destroy]

  def index
    filter
    @user = User.find params[:user] if params[:user]
  end

  def search
    search_scope
  end

  def show
    @goal = Goal.includes(:user, :comments, :subscriptions).find(params[:id])
    @subscription = Subscription.exists_for_goal_and_user?(@goal, current_user)
  end

  def new
  end

  def edit
    @goal = Goal.includes(:user, :comments, :subscriptions).find(params[:id])
    @subscription = Subscription.exists_for_goal_and_user?(@goal, current_user)
  end

  def create
    @goal.user = current_user
    if @goal.save
      flash[:success] = I18n.t 'goals.create.success'
      redirect_to @goal
    else
      flash[:error] = I18n.t 'goals.create.errors'
      render :new
    end
  end

  def update
    if @goal.update goal_params
      flash[:success] = I18n.t 'goals.update.success'
      redirect_to @goal
    else
      flash[:error] = I18n.t 'goals.update.errors'
      render :edit
    end
  end

  def destroy
    @goal.destroy
    flash[:success] = I18n.t 'goals.destroy.success'
    redirect_to goals_path
  end

  private

  def goal_params
    params.require(:goal).permit :title, :text, :score, comments_attributes: [:id, :body]
  end

end
