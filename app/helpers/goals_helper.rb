module GoalsHelper

  protected

  def filter
    @goals = Goal
                 .accessible_by(current_ability)
                 .includes(:user)
                 .filter(params.slice :user, :recent)
                 .page(params[:page])
                 .per(params[:per_page])
  end

  def search_scope
    @results = Goal
                   .accessible_by(current_ability)
                   .search_title_and_text(params[:q])
    @goals = @results
                 .includes(:user)
                 .page(params[:page])
                 .per(params[:per_page])
  end

end