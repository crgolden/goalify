module GoalsHelper

  protected

  def filter
    if params[:q]
      goals = Goal.accessible_by(current_ability).search_title_and_text params[:q]
    elsif params[:user]
      @user = User.includes(:goals).find params[:user]
      goals = @user.goals.accessible_by(current_ability)
    else
      goals = Goal.accessible_by(current_ability)
    end
    @goals = goals.includes(:user, :comments, :scores, :subscriptions, :scores).order(score: :desc).page(params[:page]).per params[:per_page]
  end

  def load_goal
    @goal = Goal.includes(:user, :comments, :subscriptions, :scores).find params[:id]
    @subscription = Subscription.exists_for_goal_and_user? @goal, current_user
  end

  def create_success
    flash[:success] = I18n.t('goals.create.success')
    redirect_to @goal
  end

  def create_errors
    flash[:error] = I18n.t('goals.create.errors')
    render :new
  end

  def update_success
    flash[:success] = I18n.t('goals.update.success')
    redirect_to @goal
  end

  def update_errors
    flash[:error] = I18n.t('goals.update.errors')
    render :edit
  end

  def destroy_success
    flash[:success] = I18n.t('goals.destroy.success')
    redirect_to goals_path
  end

end