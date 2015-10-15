class ScoresController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource :goal
  load_and_authorize_resource :score, through: :goal, shallow: true
  caches_page :index, :show
  caches_action :new, :edit

  def index
    @scores = @goal.scores.accessible_by(current_ability).page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @score = @goal.scores.new score_params
    @score.user = current_user
    if @score.save
      flash[:success] = 'Score successfully created.'
      redirect_to @score.goal
    else
      flash[:error] = 'There was a problem creating the score.'
      redirect_to @score.goal
    end
  end

  def update
    if @score.update score_params
      flash[:success] = 'Score was successfully updated.'
      redirect_to @score.goal
    else
      flash[:error] = 'There was a problem updating the score.'
      render :edit
    end
  end

  def destroy
    @score.destroy
    flash[:success] = 'Score was successfully deleted.'
    redirect_to @score.goal
  end

  private

  def score_params
    params.require(:score).permit :value
  end

end
