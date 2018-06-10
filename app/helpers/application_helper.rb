module ApplicationHelper
  def split_per_character(field, char)
    field.split(char).map do |tag|
      content_tag(:p, tag)
    end.join.html_safe
  end
end
