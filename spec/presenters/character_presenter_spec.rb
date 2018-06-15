# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharacterPresenter do
  include Rails.application.routes.url_helpers

  let(:view) { ActionController::Base.new.view_context }
  let(:character) { create(:character) }
  let(:none_or_unknown) { '<p><strong>None or unknown</strong></p>' }
  let(:unknown) { '<strong>Unknown</strong>' }

  describe 'father' do
    it 'returns None or unknown if character has no father name' do
      character.update(father_name: '')

      expect(described_class.new(character, view).father).to eq unknown
    end

    it 'returns his father name as a string if character father
      is not in the database' do
      character = create(:character, father: nil, father_name: 'Paco de Lucía')

      expect(described_class.new(character, view).father).to eq 'Paco de Lucía'
    end

    it 'returns a link to the father character' do
      father_character = create(:character)
      character = create(:character, father_name: father_character.name)

      expect(
        described_class.new(character, view).father).to match('href') &
          match("/characters/#{father_character.id}")
    end
  end

  describe 'mother' do
    it 'returns None or unknown if character has no father' do
      character.update(mother_name: '')

      expect(described_class.new(character, view).mother).to eq unknown
    end

    it 'returns his mother name as a string if character mother
      is not in the database' do
      character = create(:character, mother: nil, mother_name: 'Lola Flores')

      expect(described_class.new(character, view).mother).to eq 'Lola Flores'
    end

    it 'returns a link to the mother character' do
      mother_character = create(:character)
      character = create(:character, mother_name: mother_character.name)

      expect(described_class.new(character, view).mother).to match('href') &
        match("/characters/#{mother_character.id}")
    end
  end

  describe 'grandparents' do
    it 'returns None or unknown if have no grandparents' do
      character = create(:character, father_name: '', mother_name: '')

      expect(described_class.new(character, view).grandparents).to eq none_or_unknown
    end

    it 'returns an html list with links to each of the grandparents' do
      grandfather_character = create(:character, father_name: '', mother_name: '')
      grandmother_character = create(:character, father_name: '', mother_name: '')
      father_character = create(:character,
                                father_name: grandfather_character.name,
                                mother_name: '')
      mother_character = create(:character,
                                mother_name: grandmother_character.name,
                                father_name: '')
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)

      expect(character.father).to eq father_character
      expect(character.mother).to eq mother_character
      expect(father_character.father).to eq grandfather_character
      expect(mother_character.mother).to eq grandmother_character
      expect(described_class.new(character, view).grandparents).to match("<li><a href=\"#{character_url(grandfather_character.id)}\">#{grandfather_character.name}</a></li>")
      expect(described_class.new(character, view).grandparents).to match("<li><a href=\"#{character_url(grandmother_character.id)}\">#{grandmother_character.name}</a></li>")
    end
  end

  describe 'grandchildren' do
    it 'returns None or unknown if character has no grandchildren' do
      character = create(:character, children: '')

      expect(described_class.new(character, view).grandchildren).to eq none_or_unknown
    end

    it 'returns an html list with links to each of the grandchildren' do
      character = create(:character, children: '')
      child = create(:character, father_name: character.name,
                                 children: 'Mazinger, Afrodita, Dr. Hell')
      grandchild1 = create(:character, name: 'Mazinger', father_name: child.name)
      grandchild2 = create(:character, name: 'Afrodita', father_name: child.name)

      expect(described_class.new(character, view).grandchildren).to match("<li><a href=\"#{character_url(grandchild1.id)}\">#{grandchild1.name}</a></li>")
      expect(described_class.new(character, view).grandchildren).to match("<li><a href=\"#{character_url(grandchild2.id)}\">#{grandchild2.name}</a></li>")
    end
  end

  describe 'children' do
    it 'returns None or unknown if character has no children' do
      character = create(:character)

      expect(described_class.new(character, view).children).to eq none_or_unknown
    end

    it 'returns an html list with links to each of the children' do
      character = create(:character)
      child1 = create(:character, father_name: character.name)
      child2 = create(:character, father_name: character.name)

      expect(described_class.new(character, view).children).to match("<li><a href=\"#{character_url(child1.id)}\">#{child1.name}</a></li>")
      expect(described_class.new(character, view).children).to match("<li><a href=\"#{character_url(child2.id)}\">#{child2.name}</a></li>")
    end
  end

  describe 'siblings' do
    it 'returns None or unknown if character has no siblings' do
      character = create(:character)

      expect(described_class.new(character, view).siblings).to eq none_or_unknown
    end

    it 'returns an html list with links to each of the siblings' do
      father_character = create(:character)
      mother_character = create(:character)
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)
      brother = create(:character, father_name: father_character.name)
      sister = create(:character, mother_name: mother_character.name)

      expect(described_class.new(character, view).siblings).to match("<li><a href=\"#{character_url(brother.id)}\">#{brother.name}</a></li>")
      expect(described_class.new(character, view).siblings).to match("<li><a href=\"#{character_url(sister.id)}\">#{sister.name}</a></li>")
    end
  end

  describe 'uncles_and_aunts' do
    it 'returns None or unknown if character has neither uncles nor aunts' do
      character = create(:character, father_name: '', mother_name: '')

      expect(described_class.new(character, view).uncles_and_aunts).to eq none_or_unknown
    end

    it 'returns an html list with links to each of the siblings' do
      grandfather = create(:character)
      grandmother = create(:character)
      uncle = create(:character, father_name: grandfather.name)
      aunt = create(:character, mother_name: grandmother.name)
      father_character = create(:character, father_name: grandfather.name)
      mother_character = create(:character, mother_name: grandmother.name)
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)

      expect(described_class.new(character, view).uncles_and_aunts).to match("<li><a href=\"#{character_url(uncle.id)}\">#{uncle.name}</a></li>")
      expect(described_class.new(character, view).uncles_and_aunts).to match("<li><a href=\"#{character_url(aunt.id)}\">#{aunt.name}</a></li>")
    end
  end

  describe 'cousins' do
    it 'returns None or unknown if character has no cousins' do
      character = create(:character, father_name: '', mother_name: '')

      expect(described_class.new(character, view).cousins).to eq none_or_unknown
    end

    it 'returns an html list with links to each of the cousins' do
      grandfather = create(:character)
      grandmother = create(:character)
      uncle = create(:character, father_name: grandfather.name)
      aunt = create(:character, mother_name: grandmother.name)
      father_character = create(:character, father_name: grandfather.name)
      mother_character = create(:character, mother_name: grandmother.name)
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)
      cousin1 = create(:character, father_name: father_character.name)
      cousin2 = create(:character, mother_name: aunt.name)
      cousin3 = create(:character, mother_name: mother_character.name)
      cousin4 = create(:character, father_name: uncle.name)

      expect(described_class.new(character, view).cousins).to match("<li><a href=\"#{character_url(cousin2.id)}\">#{cousin2.name}</a></li>")
      expect(described_class.new(character, view).cousins).to match("<li><a href=\"#{character_url(cousin4.id)}\">#{cousin4.name}</a></li>")
    end
  end
end
