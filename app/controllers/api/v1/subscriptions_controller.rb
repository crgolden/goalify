class Api::V1::SubscriptionsController < Api::V1::ApiController
  acts_as_token_authentication_handler_for User, except: [:show, :index], fallback: :exception
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    @subscriptions = Subscription.accessible_by(current_ability).search(query_params)
                         .page(params[:page]).per params[:per_page]
  end

  def edit
  end

  def create
    @subscription.user = current_user
    if @subscription.save
      render @subscription.goal, status: :created, location: [:api, @subscription.goal],
             locals: {goal: @subscription.goal}
    end
  end

  def update
    if @subscription.update subscription_params
      render @subscription.goal, status: :ok, location: [:api, @subscription.goal],
             locals: {goal: @subscription.goal}
    end
  end

  def destroy
    @subscription.destroy
    head 204
  end

  private

  def subscription_params
    params.require(:subscription).permit :completed, :user_id, :goal_id
  end

  def query_params
    params.permit :id, :user_id, :goal_id, :completed
  end

end
