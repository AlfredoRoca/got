module ApplicationHelper
  def split_per_character(field, char)
    field.split(char).map do |tag|
      content_tag(:p, tag)
    end.join.html_safe
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self) # self is the template object related to the object and has the template helpers
    yield presenter if block_given?
    presenter
  end
end
