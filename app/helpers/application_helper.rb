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
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end

  def bootstrap_icon_for(flash_type)
    BOOTSTRAP_FLASH_ICON.fetch(flash_type.to_sym, 'question-sign')
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
               concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
                 concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
                 concat content_tag(:span, 'Close', class: 'sr-only')
               end)
               concat content_tag(:i, '&nbsp;'.html_safe, class: "glyphicon glyphicon-#{bootstrap_icon_for(msg_type)}")
               concat message
             end)
      flash.clear
    end
    nil
  end
end
