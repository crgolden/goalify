class Api::V1::TokensController < Api::V1::ApiController
  load_resource :user
  load_resource :token, through: :user, only: [:index]
  load_resource :token, only: [:show, :destroy]
  acts_as_token_authentication_handler_for User, only: [:index, :show, :destroy], fallback: :exception
  caches_action :index, :show

  def index
    if user_signed_in? && (current_user.admin? || current_user == @user)
      render :index
    end
  end

  def show
    if user_signed_in? && (current_user.admin? || current_user == @token.user)
      render :show
    end
  end

  def destroy
    if user_signed_in? && (current_user.admin? || current_user == @token.user)
      @token.destroy
      head 204
    end
  end

end
