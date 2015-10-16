class Api::V1::ScoresController < Api::V1::ApiController
  load_and_authorize_resource :goal
  load_and_authorize_resource :score, through: :goal, only: :index
  load_and_authorize_resource :score, only: :show

  def index
    @scores = @goal.scores.accessible_by(current_ability).page(params[:page]).per params[:per_page]
  end

  def show
  end

end
