class GoalsUsersController < ApplicationController

  before_action :authenticate_user!

  def create
    subscription = GoalsUsers.new subscription_params
    if subscription.save
      flash[:success] = I18n.t 'goals_users.create.success'
      redirect_to :back
    end
  end

  def update
    subscription = GoalsUsers.find params[:id]
    if subscription.update subscription_params
      flash[:success] = I18n.t 'goals_users.update.success'
      redirect_to :back
    end
  end

  def destroy
    subscription = GoalsUsers.find params[:id]
    subscription.destroy
    flash[:success] = I18n.t 'goals_users.destroy.success'
    redirect_to :back
  end

  private

  def subscription_params
    params.require(:subscription).permit :completed, :user_id, :goal_id
  end

end
