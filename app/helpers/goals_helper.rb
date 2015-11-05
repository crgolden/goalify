module GoalsHelper

  protected

  def init_goals
    @goals = Goal.includes(:user, :comments, :scores, :subscribers).accessible_by(current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_goal
    init_goals
    @goal = @goals.find params[:id]
    @comments = @goal.comments.accessible_by(current_ability).any?
    @scores = @goal.scores.accessible_by(current_ability).any?
    @subscribers = @goal.subscribers.accessible_by(current_ability).any?
  end

  def init_comments
    init_goal
    @comments = Kaminari.paginate_array(@goal.comments.includes(:user).accessible_by current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_scores
    init_goal
    @scores = Kaminari.paginate_array(@goal.scores.includes(:user).accessible_by current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_subscribers
    init_goal
    @subscribers = Kaminari.paginate_array(@goal.subscribers.includes(:comments, :goals, :scores, :subscriptions, :tokens).accessible_by current_ability).page(page_params[:page]).per page_params[:per_page]
  end

end
