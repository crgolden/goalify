class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource :goal
  load_and_authorize_resource :subscription, through: :user, shallow: true

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
    @subscription = @goal.subscriptions.new subscription_params
    @subscription.user = current_user
    if @subscription.save
      flash[:success] = 'Subscription successfully created.'
      render :show
      # else
      #   flash[:error] = 'There was a problem creating the subscription.'
      #   redirect_to @subscription.goal
    end
  end

  def update
    if @subscription.update subscription_params
      flash[:success] = 'Subscription was successfully updated.'
      redirect_to @subscription
      # else
      #   flash[:error] = 'There was a problem updating the subscription.'
      #   render :edit
    end
  end

  def destroy
    @subscription.destroy
    flash[:success] = 'Subscription was successfully deleted.'
    redirect_to @subscription.goal
  end

  private

  def subscription_params
    @subscription_params = params.require(:subscription).permit :completed
  end

end
