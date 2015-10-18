class Api::V1::ScoresController < Api::V1::ApiController
  include ScoresHelper
  acts_as_token_authentication_handler_for User, except: [:show, :index], fallback: :exception
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  def index
    filter
  end

  def show
  end

end
