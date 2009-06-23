# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def flash_messages
    [:notice, :warning, :message].collect do |key|
      content_tag(:div, flash[key], :class => "flash flash_#{key}") unless flash[key].blank?
    end.join
  end
end
