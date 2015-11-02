class ApplicationController < ActionController::Base

  include ApplicationHelper

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action set_resource, only: [:destroy, :show, :update]
  # before_action respond_with get_resource, only: [:show, :edit, :update, :destroy]
  # before_action instance_variable_set "@#{controller_name}", resource_class.where.page(params[:page]).per(params[:page_size]), only: [:index, :search]
  # before_action respond_with instance_variable_get, "@#{controller_name}", only: [:index, :search]
  # before_action resource_class.new send("#{resource_name}_params"), only: :create

  # GET /api/v1/{plural_resource_name}
  # def index
  #   plural_resource_name = "@#{resource_name.pluralize}"
  #   resources = resource_class.where(query_params)
  #                   .page(page_params[:page])
  #                   .per(page_params[:page_size])
  #   instance_variable_set(plural_resource_name, resources)
  #   respond_with instance_variable_get(plural_resource_name)
  # end

  # GET /api/v1/{plural_resource_name}/1
  # def show
  #   respond_with get_resource
  # end

  #   # POST /api/v1/{plural_resource_name}
  #   def create
  #     set_resource(resource_class.new(resource_params))
  #
  #     if get_resource.save
  #       render :show, status: :created, location: get_resource
  #     else
  #       render json: get_resource.errors, status: :unprocessable_entity
  #     end
  #   end

  # PATCH/PUT /api/v1/{plural_resource_name}/1
  # def update
  #   if get_resource.update(resource_params)
  #     render :show
  #   else
  #     render json: get_resource.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /api/v1/{plural_resource_name}/1
  # def destroy
  #   get_resource.destroy
  #   head :no_content
  # end

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = I18n.t 'cancan.ability.error'
    request.env['HTTP_REFERER'].present? ? redirect_to(:back) : redirect_to(root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  private

  # Returns the allowed parameters for pagination
  # @return [Hash]
  def page_params
    params.permit :page, :per_page
  end

  # Returns the allowed parameters for searching
  # Override this method in each API controller
  # to permit additional parameters to search on
  # @return [Hash]
  def query_params
    params.permit :q
  end

  # Only allow a trusted parameter "white list" through.
  # If a single resource is loaded for #create or #update,
  # then the controller for the resource must implement
  # the method "#{resource_name}_params" to limit permitted
  # parameters for the individual model.
  def resource_params
    @resource_params ||= self.send("#{resource_name}_params")
  end

end
