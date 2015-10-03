module TokensHelper
  def destroy_success
    flash[:success] = 'Token was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to @token.user }
      format.json { head :no_content }
    end
  end
end
