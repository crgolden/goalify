module UsersHelper

  protected

  def init_users
    @users = User.includes(:comments, :goals, :scores, :subscriptions, :tokens).accessible_by(current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_user
    init_users
    @user = @users.find params[:id]
    @comments = @user.comments.accessible_by(current_ability).any?
    @goals = @user.goals.accessible_by(current_ability).any?
    @scores = @user.scores.accessible_by(current_ability).any?
    @subscriptions = @user.subscriptions.accessible_by(current_ability).any?
    @tokens = @user.tokens.accessible_by(current_ability).any?
  end

  def init_comments
    init_user
    @comments = Kaminari.paginate_array(@user.comments.includes(:goal).accessible_by current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_goals
    init_user
    @goals = Kaminari.paginate_array(@user.goals.includes(:comments, :scores, :subscribers).accessible_by current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_scores
    init_user
    @scores = Kaminari.paginate_array(@user.scores.includes(:goal).accessible_by current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_subscriptions
    init_user
    @subscriptions = Kaminari.paginate_array(@user.subscriptions.includes(:user, :comments, :subscribers).accessible_by current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def init_tokens
    init_user
    @tokens = Kaminari.paginate_array(@user.tokens.accessible_by current_ability).page(page_params[:page]).per page_params[:per_page]
  end

  def check_password
    false unless user_params[:password].blank?
    user_params.delete :password
    user_params.delete :password_confirmation
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
