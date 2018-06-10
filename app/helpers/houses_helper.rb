module HousesHelper
  def format_general_info(label, value)
    content_tag :div, :class => ["col-md-6", "col-lg-6", "col-xs-12"] do
      content_tag(:h2, label.capitalize) +
      content_tag(:p, split_per_character(value, ","))
    end if value
  end

  def show_house_general_info_fields
    %w(seat religion lord region)
  end

end