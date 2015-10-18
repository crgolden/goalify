module GoalsHelper

  protected

  def filter
    @goals = Goal.accessible_by(current_ability).page(params[:page]).per(params[:per_page])
                 .filter(params.slice :user_id, :filter_title, :recent)
  end

end