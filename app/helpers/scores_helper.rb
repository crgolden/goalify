module ScoresHelper

  protected

  def filter
    if params[:goal]
      @goal = Goal.includes(:scores).find params[:goal]
      scores = @goal.scores
    elsif params[:user]
      @user = User.includes(:scores).find params[:user]
      scores = @user.scores
    elsif params[:subscription]
      @subscription = Subscription.includes(:scores).find params[:subscription]
      scores = @subscription.scores
    else
      scores = Score.all
    end
    @scores = scores.accessible_by(current_ability).includes(:subscription).page(params[:page]).per params[:per_page]
  end

end