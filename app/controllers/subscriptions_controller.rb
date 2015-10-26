class SubscriptionsController < ApplicationController
  include SubscriptionsHelper
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    filter
  end

  def create
    @subscription.user = current_user
    create_success if @subscription.save
  end

  def update
    update_success if @subscription.update subscription_params
  end

  def destroy
    @subscription.destroy
    destroy_success
  end

  private

  def subscription_params
    params.require(:subscription).permit :completed, :user_id, :goal_id
  end

end
