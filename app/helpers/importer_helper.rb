module ImporterHelper
  def import_result(character)
    character.persisted? ? successful_import(character) : failed_import(character)
  end

  protected

  def successful_import(character)
		link_to character.name, character
  end

  def failed_import(character)
    content_tag :ul do
      character.errors.full_messages.map do |m|
        content_tag :ul, m
      end
    end
  end
end
