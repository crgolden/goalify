class Api::V1::TokensController < Api::V1::ApiController
  acts_as_token_authentication_handler_for User, fallback: :exception
  before_action :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource :token, through: :user, only: [:index]
  load_and_authorize_resource :token, only: [:show, :destroy]
  caches_action :index, :show

  def index
  end

  def show
  end

  def destroy
    @token.destroy
    head 204
  end

end
