class TokensController < ApplicationController
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
    flash[:success] = I18n.t 'tokens.destroy.success'
    session[:referrer] ? redirect_to(session[:referrer]) : redirect_to(:back)
  end

end
