class TokensController < ApplicationController

  before_action :authenticate_user!

  load_and_authorize_resource

  def destroy
    @token.destroy
    flash[:success] = I18n.t 'tokens.destroy.success'
    redirect_to tokens_user_path(@token.user)
  end

end
