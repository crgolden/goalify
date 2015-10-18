class ScoresController < ApplicationController
  include ScoresHelper
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    filter
  end

  def show
  end

end
