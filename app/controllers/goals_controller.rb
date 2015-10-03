class GoalsController < ApplicationController
  include GoalsHelper
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
    @goal.save ? create_success : create_errors
  end

  def update
    @goal.update(goal_params) ? update_success : update_errors
  end

  def destroy
    destroy_success if @goal.destroy
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :text)
  end
end
