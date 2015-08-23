module ApplicationHelper
  def error_messages_for(form, attribute)
    messages = form.object.errors.full_messages_for(attribute)

    if messages.any?
      content_tag(:p, messages.join(". ") << ".", class: "help-block")
    end
  end
end
