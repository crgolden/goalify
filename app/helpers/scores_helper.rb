module ScoresHelper

  def filter
    @scores = Score.accessible_by(current_ability).page(params[:page]).per(params[:per_page])
                  .filter(params.slice :goal_id, :user_id)
  end

end