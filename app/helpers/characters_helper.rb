module CharactersHelper
  def format_fields(field, character_field)
    content_tag :div, :class => ["col-md-3", "col-sm-3", "col-lg-3", "col-xs-12"] do
      content_tag(:h2, field.capitalize) +
      content_tag(:p, split_per_character(character_field, ","))
    end if character_field
  end

  def show_character_relationship_fields
    %w(father mother spouse children siblings predecessor successor lovers)
  end

  def show_character_beliefs_fields
    %w(origin culture allegiance religion)
  end
end
