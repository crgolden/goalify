class Api::V1::SubscriptionsController < Api::V1::ApiController
  load_and_authorize_resource :goal
  load_and_authorize_resource :subscription, through: :goal, shallow: true

  def index
    @subscriptions = @goal.subscriptions.accessible_by(current_ability).page(params[:page]).per params[:per_page]
  end

  def show
  end

  def edit
  end

  def create
    @subscription = @goal.subscriptions.create subscription_params
    @subscription.user = current_user
    if @subscription.save
      render :show, status: :created, location: [:api, @subscription]
    end
  end

  def update
    if @subscription.update subscription_params
      render :show, status: :ok, location: [:api, @subscription]
    end
  end

  def destroy
    @subscription.destroy
    head 204
  end

  private

  def subscription_params
    params.require(:subscription).permit :completed
  end

end
