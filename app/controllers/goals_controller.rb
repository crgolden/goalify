class GoalsController < ApplicationController

  include GoalsHelper

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  authorize_resource only: [:index, :show, :edit, :comments, :scores, :search, :subscribers]
  load_and_authorize_resource only: [:update, :destroy]
  load_and_authorize_resource only: [:new, :create], through: :current_user

  caches_page :index, :show, :comments, :scores, :search, :subscribers
  caches_action :new, :edit

  def index
    @goals = init_goals
  end

  def show
    @goal = init_goal
  end

  def new
  end

  def edit
    @goal = init_goal
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
    @comments = Kaminari.paginate_array(init_comments).page(page_params[:page]).per page_params[:per_page]
  end

  def scores
    @scores = Kaminari.paginate_array(init_scores).page(page_params[:page]).per page_params[:per_page]
  end

  def search
    @goals = init_search
  end

  def subscribers
    @subscribers = Kaminari.paginate_array(init_subscribers).page(page_params[:page]).per page_params[:per_page]
  end

  private

  def goal_params
    params.require(:goal).permit :title, :text, :user_id
  end

end
