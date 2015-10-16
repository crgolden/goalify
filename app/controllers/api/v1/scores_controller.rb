class Api::V1::ScoresController < Api::V1::ApiController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_resource :goal
  load_resource :score, through: :goal, shallow: true
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
    if user_signed_in?
      @scores = @goal.scores.create(score_params)
      @score.user = current_user
      if @score.save
        render :show, status: :created, location: [:api, @score]
      else
        render json: @score.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if user_signed_in? && (current_user.admin? || (current_user == @score.user))
      if @score.update(score_params)
        render :show, status: :ok, location: [:api, @score]
      else
        render json: @score.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if user_signed_in? && (current_user.admin? || (current_user == @score.user))
      @score.destroy
      head 204
    end
  end

  private

  def score_params
    params.require(:score).permit(:value)
  end

  # def query_params
  #   params.permit(:id, :user_id, :goal_id, :body,)
  # end

end
