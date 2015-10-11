module Users::OmniauthCallbacksHelper
  def token_exists_for_uid_provider?
    Token.exists_for_uid_and_provider?(@auth)
  end

  def user_exists_for_email?
    User.exists_for_email?(@auth.info.email)
  end

  def new_token_from_omniauth(user)
  Token.from_omniauth(@auth, user)
  end

  def new_user_from_omniauth
    User.from_omniauth(@auth.info)
  end
end
