class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  caches_page :index, :show
  caches_action :new, :edit

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = 'Access denied!'
    request.env['HTTP_REFERER'].present? ? redirect_to(:back) : redirect_to(root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

end
