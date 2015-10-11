class TokensController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource :token, through: :user, only: [:index]
  load_and_authorize_resource :token, only: [:show, :destroy]

  def index
  end

  def show
  end

  def destroy
    @token.destroy
    flash[:success] = 'Token was successfully deleted.'
    redirect_to @token.user
  end

  private

  def token_params
  end
end
