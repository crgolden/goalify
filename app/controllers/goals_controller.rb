class GoalsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
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
      flash[:success] = 'Goal successfully created.'
      render :show
    else
      flash[:error] = 'There was a problem creating the goal.'
      render :new
    end
  end

  def update
    if @goal.update(goal_params)
      flash[:success] = 'Goal was successfully updated.'
      redirect_to @goal
    else
      flash[:error] = 'There was a problem updating the goal.'
      render :edit
    end
  end

  def destroy
    @goal.destroy
    flash[:success] = 'Goal was successfully deleted.'
    redirect_to goals_path
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :text)
  end
end
