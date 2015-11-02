module GoalsHelper

  protected

  def init_goals
    Goal.includes(user: [], comments: :user, scores: :user, subscribers: [:comments, :goals, :subscriptions, :tokens]).accessible_by(current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_goal
    @goal = init_goals.includes(:user).find params[:id]
  end

  def init_comments
    init_goal.comments.accessible_by(current_ability).includes :user
  end

  def init_scores
    init_goal.scores.accessible_by(current_ability).includes :user
  end

  def init_search
    init_goals.search_title_and_text query_params
  end

  def init_subscribers
    init_goal.subscribers.accessible_by(current_ability).includes :comments, :goals, :subscriptions, :tokens
  end

end