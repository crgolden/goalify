module ApplicationHelper

  BOOTSTRAP_FLASH_MSG = {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
  }

  BOOTSTRAP_FLASH_ICON = {
      success: 'ok-sign',
      error: 'remove-sign',
      alert: 'exclamation-sign',
      notice: 'info-sign'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch flash_type.to_sym, flash_type.to_s
  end

  def bootstrap_icon_for(flash_type)
    BOOTSTRAP_FLASH_ICON.fetch flash_type.to_sym, 'question-sign'
  end

  private

  # Returns the resource from the created instance variable
  # @return [Object]
  def get_resource
    instance_variable_get "@#{resource_name}"
  end

  # The resource class based on the controller
  # @return [Class]
  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  # The singular name for the resource class based on the controller
  # @return [String]
  def resource_name
    @resource_name ||= controller_name.singularize
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_resource(resource = nil)
    resource ||= resource_class.find params[:id]
    instance_variable_set "@#{resource_name}", resource
  end

end
