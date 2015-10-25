module CommentsHelper

  protected

  def filter
    @comments = Comment
                    .accessible_by(current_ability)
                    .includes(:goal, :user)
                    .filter(params.slice :goal, :user)
                    .page(params[:page])
                    .per(params[:per_page])
  end

end