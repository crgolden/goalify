module TokensHelper
  def destroy_success
    flash[:success] = 'Token was successfully deleted.'
    redirect_to @token.user
  end
end
