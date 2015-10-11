class ApplicationController < ActionController::Base
  include ApplicationHelper

  if Proc.new { |c| c.request.format.json? }
    protect_from_forgery with: :null_session
  else
    protect_from_forgery with: :exception
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = 'Access denied!'
    redirect_to :back
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end
end
