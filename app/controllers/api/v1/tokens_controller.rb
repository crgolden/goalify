class Api::V1::TokensController < Api::V1::ApiController

  acts_as_token_authentication_handler_for User, fallback: :exception

  before_action :authenticate_user!

  load_and_authorize_resource

  def destroy
    @token.destroy
    head 204
  end

end
