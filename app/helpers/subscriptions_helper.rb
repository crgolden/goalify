module SubscriptionsHelper

  def filter
    @subscriptions = Subscription.accessible_by(current_ability).filter(params.slice :goal_id, :user_id)
                         .page(params[:page]).per(params[:per_page])
  end

end