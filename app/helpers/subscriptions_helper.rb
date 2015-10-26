module SubscriptionsHelper

  protected

  def filter
    if params[:goal]
      @goal = Goal.includes(:subscriptions).find params[:goal]
      subscriptions = @goal.subscriptions
    elsif params[:user]
      @user = User.includes(:subscriptions).find params[:user]
      subscriptions = @user.subscriptions
    else
      subscriptions = Subscription.all
    end
    @subscriptions = subscriptions.accessible_by(current_ability).includes(:user, :goal, :scores).page(params[:page]).per params[:per_page]
  end

  def create_success
    flash[:success] = I18n.t('subscriptions.create.success')
    redirect_to :back
  end

  def update_success
    flash[:success] = I18n.t('subscriptions.update.success')
    redirect_to :back
  end

  def destroy_success
    flash[:success] = I18n.t('subscriptions.destroy.success')
    redirect_to :back
  end

end