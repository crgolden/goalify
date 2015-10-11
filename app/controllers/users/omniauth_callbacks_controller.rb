class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Users::OmniauthCallbacksHelper

  def self.provides_callback_for(*providers)
    providers.each do |provider|
      class_eval %Q{
        def #{provider}
          @auth = request.env['omniauth.auth']
          if token = token_exists_for_uid_provider?
            sign_in_and_redirect token.user
            flash[:success] = I18n.t 'devise.omniauth_callbacks.success',
                                     kind: "#{provider}".titleize if is_navigational_format?
          elsif @auth.info.email.blank?
            redirect_to user_omniauth_authorize_path provider: "#{provider}", auth_type: :rerequest, scope: :email
          elsif user = user_exists_for_email?
            new_token_from_omniauth user
            sign_in_and_redirect user
            flash[:success] = I18n.t 'devise.omniauth_callbacks.success',
                                     kind: "#{provider}".titleize if is_navigational_format?
          elsif user = new_user_from_omniauth
            new_token_from_omniauth user
            sign_in_and_redirect user
            flash[:success] = I18n.t 'devise.omniauth_callbacks.success',
                                     kind: "#{provider}".titleize if is_navigational_format?
          else
            session["devise.#{provider}_data"] = @auth
            redirect_to new_user_registration_url
            flash[:error] = I18n.t 'devise.omniauth_callbacks.failure',
                                   kind: "#{provider}".titleize, reason: 'Invalid credentials'
          end
        end
      }
    end
  end

  provides_callback_for :google_oauth2, :facebook
end
