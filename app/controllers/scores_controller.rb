class ScoresController < ApplicationController
  include ScoresHelper
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    filter
    @subscription = Subscription.find params[:subscription] if params[:subscription]
    @goal = Goal.find params[:goal] if params[:goal]
    @user = User.find params[:user] if params[:user]
  end

  def show
  end

end
