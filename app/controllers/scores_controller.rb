class ScoresController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    @scores = Score.accessible_by(current_ability).page(params[:page]).per(params[:per_page])
                  .filter(params.slice :goal_id, :user_id)
  end

  def show
  end

  private

  def query_params
    params.permit :id, :user_id, :goal_id, :value
  end

end
