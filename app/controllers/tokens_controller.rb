class TokensController < ApplicationController
  include TokensHelper
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
    destroy_success
  end

end
