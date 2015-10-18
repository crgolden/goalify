class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    @subscriptions = Subscription.accessible_by(current_ability)
                         .page(params[:page]).per(params[:per_page])
                         .filter(params.slice :goal_id, :user_id)
  end

  def edit
  end

  def create
    @subscription.user = current_user
    if @subscription.save
      flash[:success] = I18n.t 'subscriptions.create.success'
      redirect_to @subscription.goal
    end
  end

  def update
    if @subscription.update subscription_params
      flash[:success] = I18n.t 'subscriptions.update.success'
      redirect_to @subscription.goal
    end
  end

  def destroy
    @subscription.destroy
    flash[:success] = I18n.t 'subscriptions.destroy.success'
    redirect_to :back
  end

  private

  def subscription_params
    @subscription_params = params.require(:subscription).permit :completed, :user_id, :goal_id
  end

  def query_params
    params.permit :id, :user_id, :goal_id, :completed
  end

end
