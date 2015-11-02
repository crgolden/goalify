module UsersHelper

  protected

  def check_password
    false unless user_params[:password].blank?
    user_params.delete [:password, :password_confirmation]
  end

  def init_users
    User.includes(comments: :goal, goals: [:comments, :subscribers], scores: :goal, subscriptions: [:user, :comments, :subscribers], tokens: []).accessible_by(current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_user
    @user = init_users.find params[:id]
  end

  def init_comments
    init_user.comments.accessible_by(current_ability).includes :goal
  end

  def init_goals
    init_user.goals.accessible_by(current_ability).includes :comments, :subscribers
  end

  def init_scores
    init_user.scores.accessible_by(current_ability).includes :goal
  end

  def init_search
    init_users.search_name query_params
  end

  def init_subscriptions
    init_user.subscriptions.accessible_by(current_ability).includes :user, :comments, :subscribers
  end

  def init_tokens
    init_user.tokens.accessible_by current_ability
  end

  def needs_password?
    user_params[:password].present? || user_params[:password_confirmation].present?
  end

  def update_current_user
    if @user == current_user
      @current_ability = nil
      @current_user = nil
    end
  end

end
