class TokensController < ApplicationController
  before_action :authenticate_user!
  caches_action :index, :show
  load_and_authorize_resource :user
  load_and_authorize_resource :token, through: :user, only: [:index]
  load_and_authorize_resource :token, only: [:show, :destroy]

  def index
  end

  def show
  end

  def destroy
    @token.destroy
    flash[:success] = I18n.t 'tokens.destroy.success'
    redirect_to @token.user
  end

end
