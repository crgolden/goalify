module SubscriptionsHelper

  protected

  def filter
    @subscriptions = Subscription
                         .accessible_by(current_ability)
                         .includes(:user, :goal, :scores)
                         .filter(params.slice :goal, :user)
                         .page(params[:page])
                         .per(params[:per_page])
  end

end