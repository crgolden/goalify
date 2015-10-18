class GoalsController < ApplicationController
  include GoalsHelper
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
    params.require(:goal).permit :title, :text, comments_attributes: [:id, :body]
  end

end
