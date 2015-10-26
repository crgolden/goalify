module TokensHelper

  protected

  def destroy_success
    flash[:success] = I18n.t('tokens.destroy.success')
    redirect_to user_tokens_path(@token.user)
  end

end