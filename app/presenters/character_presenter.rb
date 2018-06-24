# frozen_string_literal: true

class CharacterPresenter < BasePresenter
  include Rails.application.routes.url_helpers

  presents :character

  def father
    if character.father.nil?
      character.father_name.present? ? character.father_name : unknown
    else
      h.link_to character.father.name, character_url(character.father.id)
    end
  end

  def mother
    if character.mother.nil?
      character.mother_name.present? ? character.mother_name : unknown
    else
      h.link_to character.mother.name, character_url(character.mother.id)
    end
  end

  def grandparents
    present_relatives(:grandparents)
  end

  def grandchildren
    present_relatives(:grandchildren)
  end

  def children
    present_relatives(:children_characters)
  end

  def siblings
    present_relatives(:siblings_characters)
  end

  def uncles_and_aunts
    present_relatives(:uncles_and_aunts)
  end

  def cousins
    present_relatives(:cousins)
  end

  private

  def present_relatives(relationship)
    return none_or_unknown if character.send(relationship).empty?

    content = content_tag(:ul) do
      character.send(relationship).each do |relative|
        if relative.class == String
          concat content_tag(:li, relative.strip)
        else
          concat content_tag(:li, h.link_to(relative.name, character_url(relative.id)))
        end
      end
    end
    content.html_safe
  end

  def none_or_unknown
    content_tag(:p, content_tag(:strong, 'None or unknown')).html_safe
  end

  def unknown
    content_tag(:strong, 'Unknown').html_safe
  end
end
