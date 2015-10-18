class GoalsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    @goals = Goal.accessible_by(current_ability).search(query_params)
                 .page(params[:page]).per params[:per_page]
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

  def query_params
    params.permit :id, :user_id, :title, :text
  end

end
