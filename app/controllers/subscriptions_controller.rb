class SubscriptionsController < ApplicationController
  include SubscriptionsHelper
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    filter
    if params[:goal]
      @goal = Goal.find params[:goal]
    elsif params[:user]
      @user = User.find params[:user]
    end
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
    redirect_to subscriptions_path
  end

  private

  def subscription_params
    params.require(:subscription).permit :completed, :user_id, :goal_id
  end

end
