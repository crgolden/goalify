class Api::V1::GoalsUsersController < Api::V1::ApiController

  acts_as_token_authentication_handler_for User, fallback: :exception

  before_action :authenticate_user!

  wrap_parameters :subscription, format: :json

  def create
    subscription = GoalsUsers.new subscription_params
    if subscription.save
      render partial: 'api/v1/goals/goal.json.jbuilder', status: :created, location: [:api, subscription.goal], locals: {goal: subscription.goal}
    end
  end

  def update
    subscription = GoalsUsers.find params[:id]
    if subscription.update subscription_params
      render partial: 'api/v1/goals/goal.json.jbuilder', status: :ok, location: [:api, subscription.goal], locals: {goal: subscription.goal}
    end
  end

  def destroy
    subscription = GoalsUsers.find params[:id]
    subscription.destroy
    head 204
  end

  private

  def subscription_params
    params.permit :completed, :user_id, :goal_id
  end

end
