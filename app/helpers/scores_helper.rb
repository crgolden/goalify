module ScoresHelper

  protected

  def filter
    @scores = Score
                  .accessible_by(current_ability)
                  .includes(:subscription)
                  .filter(params.slice :goal, :subscription, :user)
                  .page(params[:page])
                  .per(params[:per_page])
  end

end