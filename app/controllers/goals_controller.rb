class GoalsController < ApplicationController
  include GoalsHelper
  before_action :authenticate_user!, except: [:show, :index]
  authorize_resource only: [:index, :show, :edit]
  load_and_authorize_resource only: [:new, :create, :update, :destroy]

  def index
    filter
  end

  def show
    load_goal
  end

  def new
  end

  def edit
    load_goal
  end

  def create
    @goal.user = current_user
    @goal.save ? create_success : create_errors
  end

  def update
    @goal.update(goal_params) ? update_success : update_errors
  end

  def destroy
    @goal.destroy
    destroy_success
  end

  private

  def goal_params
    params.require(:goal).permit :title, :text, :score, comments_attributes: [:id, :body]
  end

end
