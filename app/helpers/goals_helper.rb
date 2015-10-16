module GoalsHelper

  protected

  def subscription_exists_for_user?
    Subscription.exists_for_goal_and_user? @goal, current_user
  end

end
