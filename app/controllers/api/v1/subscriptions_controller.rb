class Api::V1::SubscriptionsController < Api::V1::ApiController
  before_action :authenticate_user!
  load_resource :goal
  load_resource :subscription, through: :goal, shallow: true
  caches_action :index, :show, :new, :edit

  def index
    @subscriptions = @goal.subscriptions.accessible_by(current_ability).page(params[:page]).per params[:per_page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if user_signed_in?
      @subscription = @goal.subscriptions.create(subscription_params)
      @subscription.user = current_user
      if @subscription.save
        render :show, status: :created, location: [:api, @subscription]
      else
        render json: @subscription.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if user_signed_in? && (current_user.admin? || (current_user == @subscription.user))
      if @subscription.update(subscription_params)
        render :show, status: :ok, location: [:api, @subscription]
      else
        render json: @subscription.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if user_signed_in? && (current_user.admin? || (current_user == @subscription.user))
      @subscription.destroy
      head 204
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:completed)
  end

  # def query_params
  #   params.permit(:id, :user_id, :goal_id, :body,)
  # end

end
