# frozen_string_literal: true

# == Schema Information
#
# Table name: characters
#
#  id                  :integer          not null, primary key
#  name                :string
#  house_id            :integer
#  description         :string
#  biography           :string
#  personality         :string
#  titles              :string
#  status              :string
#  death               :string
#  origin              :string
#  allegiance          :string
#  religion            :string
#  predecessor         :string
#  successor           :string
#  father              :string
#  mother              :string
#  spouse              :string
#  children            :string
#  siblings            :string
#  lovers              :string
#  culture             :string
#  appears_in_season_1 :boolean
#  appears_in_season_2 :boolean
#  appears_in_season_3 :boolean
#  appears_in_season_4 :boolean
#  appears_in_season_5 :boolean
#  appears_in_season_6 :boolean
#  appears_in_season_7 :boolean
#  appears_in_season_8 :boolean
#  appears_in_season_9 :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

RSpec.describe Character, type: :model do
  describe 'validation' do
    let(:character) { build(:character) }

    it 'rejects without name', :aggregate_failures do
      character.name = nil
      expect(character.valid?).to be false
      expect(character.errors.messages.include?(:name)).to be true
    end

    it 'rejects if name already exists', :aggregate_failures do
      person = create(:character)
      character.name = person.name
      expect(character.valid?).to be false
      expect(character.errors.messages.include?(:name)).to be true
    end

    it 'rejects without description', :aggregate_failures do
      character.description = nil
      expect(character.valid?).to be false
      expect(character.errors.messages.include?(:description)).to be true
    end

    it 'rejects without house', :aggregate_failures do
      character.house = nil
      expect(character.valid?).to be false
      expect(character.errors.messages.include?(:house)).to be true
    end

    it 'accepts with name, description and house' do
      expect(character.valid?).to be true
    end
  end

  describe 'create_with' do
    let!(:house) { create :house, name: 'House Targaryen' }
    let(:valid_character_row_hash) do
      {
        'name': 'Vermithrax',
        'description': 'Vermithrax​ was a dragon who was bred by House _
        Targaryen.',
        'biography': '', 'personality': '', 'seasons': '2, 5 ,7 ,10',
        'titles': '', 'status': '', 'death': '', 'origin': '', 'allegiance': '',
        'culture': '', 'religion': '', 'predecessor': '', 'successor': '',
        'father': 'Pepe', 'mother': 'Lola', 'spouse': '', 'children': '',
        'siblings': '', 'lovers': '',
        'image_1_src': 'http://source_of_image.com/image1.png',
        'image_1_caption': 'image1_caption',
        'image_2_src': 'http://source_of_image.com/image2.png',
        'image_2_caption': 'image2_caption',
        'image_3_src': 'http://source_of_image.com/image3.png',
        'image_3_caption': 'image3_caption',
        'image_4_src': 'http://source_of_image.com/image4.png',
        'image_4_caption': 'image4_caption',
        'image_5_src': 'http://source_of_image.com/image5.png',
        'image_5_caption': 'image5_caption',
        'image_6_src': 'http://source_of_image.com/image6.png',
        'image_6_caption': 'image6_caption',
        'image_7_src': 'http://source_of_image.com/image7.png',
        'image_7_caption': 'image7_caption',
        'image_8_src': 'http://source_of_image.com/image8.png',
        'image_8_caption': 'image8_caption',
        'house': 'House Targaryen'
      }
    end

    it 'returns nil if the information is nil' do
      expect(described_class.create_with(nil)).to be nil
    end

    context 'with valid information' do
      it 'creates a new Character' do
        row_hash = valid_character_row_hash
        expect { described_class.create_with(row_hash) }
          .to change(Character, :count).by(1)
      end

      it 'returns a hash that contains imported true' do
        row_hash = valid_character_row_hash
        expect(described_class.create_with(row_hash)[:imported]).to be true
      end

      it 'returns a hash that contains the new imported character' do
        row_hash = valid_character_row_hash
        expect(described_class.create_with(row_hash)[:character].class)
          .to be Character
      end

      it 'process season appearances for data like "2, 5, 7, 10"',
         :aggregate_failures do
        row_hash = valid_character_row_hash
        character = described_class.create_with(row_hash)[:character]
        expect(character.appears_in_season_1).to be_falsy
        expect(character.appears_in_season_2).to be true
        expect(character.appears_in_season_3).to be_falsy
        expect(character.appears_in_season_4).to be_falsy
        expect(character.appears_in_season_5).to be true
        expect(character.appears_in_season_6).to be_falsy
        expect(character.appears_in_season_7).to be true
        expect(character.appears_in_season_8).to be_falsy
        expect(character.appears_in_season_9).to be_falsy
      end

      it 'adds the images' do
        row_hash = valid_character_row_hash
        character = described_class.create_with(row_hash)[:character]
        expect(character.images.count).to eq 8
      end

      it 'saves parents names in their fields' do
        row_hash = valid_character_row_hash
        character = described_class.create_with(row_hash)[:character]
        expect(character.father_name).to eq 'Pepe'
        expect(character.mother_name).to eq 'Lola'
      end
    end

    context 'without description' do
      it 'can not create a new Character' do
        row_hash = valid_character_row_hash.merge(description: '')
        expect { described_class.create_with(row_hash) }
          .to change(Character, :count).by(0)
      end

      it 'returns a hash that contains imported false' do
        row_hash = valid_character_row_hash.merge(description: '')
        expect(described_class.create_with(row_hash)[:imported]).to be false
      end

      it 'returns a hash that contains the errors' do
        row_hash = valid_character_row_hash.merge(description: '')
        expect(described_class.create_with(row_hash)[:errors]).not_to be_empty
      end
    end
  end

  describe 'get_images_from' do
    let(:valid_character_row_hash) do
      {
        'name': 'Vermithrax',
        'description': 'Vermithrax​ was a dragon who was bred by House _
        Targaryen.',
        'biography': '', 'personality': '', 'seasons': '2, 5 ,7 ,10',
        'titles': '', 'status': '', 'death': '', 'origin': '', 'allegiance': '',
        'culture': '', 'religion': '', 'predecessor': '', 'successor': '',
        'father': '', 'mother': '', 'spouse': '', 'children': '',
        'siblings': '', 'lovers': '',
        'image_1_src': 'http://source_of_image.com/image1.png',
        'image_1_caption': 'image1_caption',
        'image_2_src': 'http://source_of_image.com/image2.png',
        'image_2_caption': 'image2_caption',
        'image_3_src': 'http://source_of_image.com/image3.png',
        'image_3_caption': 'image3_caption',
        'image_4_src': 'http://source_of_image.com/image4.png',
        'image_4_caption': 'image4_caption',
        'image_5_src': 'http://source_of_image.com/image5.png',
        'image_5_caption': 'image5_caption',
        'image_6_src': 'http://source_of_image.com/image6.png',
        'image_6_caption': 'image6_caption',
        'image_7_src': 'http://source_of_image.com/image7.png',
        'image_7_caption': 'image7_caption',
        'image_8_src': 'http://source_of_image.com/image8.png',
        'image_8_caption': 'image8_caption',
        'house': 'House Targaryen'
      }
    end

    it 'returns an array of Images' do
      row_hash = valid_character_row_hash
      expect(described_class.get_images_from(row_hash).class).to eq Array
    end

    it 'the size of the array is equal to the quantity of images' do
      row_hash = valid_character_row_hash
      expect(described_class.get_images_from(row_hash).size).to eq 8
    end

    it 'creates some image without caption' do
      row_hash = valid_character_row_hash
      row_hash[:image_1_caption] = ''
      expect(described_class.get_images_from(row_hash).size).to eq 8
    end

    it 'does not create any image without source' do
      row_hash = valid_character_row_hash
      row_hash[:image_1_src] = ''
      expect(described_class.get_images_from(row_hash).size).to eq 7
    end
  end

  def prepare_characters
    @father = create(:character, name: 'Paco', description: 'Paco is father',
                                 house: house, father_name: '', mother_name: '')
    @mother = create(:character, name: 'Lola', description: 'Lola is mother',
                                 house: house, father_name: '', mother_name: '')
  end

  describe 'search_and_save_parent_with_diagnosis' do
    let(:house) { create :house }
    let(:son) do
      create(:character, name: 'Jose', description: 'Jose is son',
                         house: house, father_name: '', mother_name: '')
    end

    it 'assigns a character as father found by name on father field' do
      prepare_characters
      son.update(father_name: 'Paco')
      son.search_and_save_parent_with_diagnosis('father')

      expect(son.father.name).to eq @father.name
    end

    it 'assigns a character as mother found by name on mother field' do
      prepare_characters
      son.update(mother_name: 'Lola')
      son.search_and_save_parent_with_diagnosis('mother')

      expect(son.mother.name).to eq @mother.name
    end

    it 'returns not found when father or mother name is missing and sons name _
      is not in any children field' do
      prepare_characters
      response = son.search_and_save_parent_with_diagnosis('father')

      expect(response[:diagnosis]) =~ 'not found'
    end

    it 'returns possible fathers found by their children when father character _
      not found by name' do
      prepare_characters
      @father.update(children: 'Jose')
      son.update(father_name: 'Paquito')
      response = son.search_and_save_parent_with_diagnosis('father')

      expect(response[:diagnosis]) =~ @father.name
    end

    it 'returns possible mothers found by their children when mother character _
      not found by name' do
      prepare_characters
      @mother.update(children: 'Jose')
      son.update(mother_name: 'Lolita')
      response = son.search_and_save_parent_with_diagnosis('mother')

      expect(response[:diagnosis]) =~ @mother.name
    end

    it 'returns not found when father character not found neither by name _
      nor children' do
      prepare_characters
      son.update(father_name: 'Pacote')
      response = son.search_and_save_parent_with_diagnosis('father')

      expect(response[:diagnosis]) =~ @mother.name
    end
  end

  let(:character) { create(:character) }

  describe 'parents' do
    it 'returns none if character neither has no declared parents
      and nobody has declared it as children' do
      character = create(:character, father_name: '', mother_name: '')

      expect(character.parents.class).to be Character::ActiveRecord_Relation
      expect(character.parents).to be_empty
    end

    it 'returns none if character declared parents are
      not in the database' do
      character = create(:character,
                         father_name: 'Paco de Lucía', mother_name: 'Lola Flores')

      expect(character.parents.class).to be Character::ActiveRecord_Relation
      expect(character.parents).to be_empty
    end

    it 'returns the parents' do
      father_character = create(:character)
      mother_character = create(:character)
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)

      expect(character.parents.class).to be Character::ActiveRecord_Relation
      expect(character.parents).to include(father_character, mother_character)
    end
  end

  describe 'children_characters' do
    it 'returns none if character has no children and nobody has declared
      him as parent' do
      character = create(:character, children: '')

      expect(character.children_characters.class).to be Character::ActiveRecord_Relation
      expect(character.children_characters).to be_empty
    end

    it 'returns none if character has declared children but they do not exist' do
      character = create(:character, children: 'Fernando Alonso')

      expect(character.children_characters.class).to be Character::ActiveRecord_Relation
      expect(character.children_characters).to be_empty
    end

    it 'returns children' do
      child1 = create(:character)
      child2 = create(:character)
      character = create(:character, children: "#{child1.name}, #{child2.name}")
      child3 = create(:character, father_name: character.name)
      child4 = create(:character, father_name: character.name)

      expect(character.children_characters).to include(child3, child4)
    end
  end

  describe 'grandparents' do
    it 'returns none if character neither has no declared parents
      and nobody has declared it as children' do
      character = create(:character, father_name: '', mother_name: '')

      expect(character.grandparents.class).to be Character::ActiveRecord_Relation
      expect(character.grandparents).to be_empty
    end

    it 'returns none if character declared parents are
      not in the database' do
      character = create(:character,
                         father_name: 'Paco de Lucía', mother_name: 'Lola Flores')

      expect(character.grandparents.class).to be Character::ActiveRecord_Relation
      expect(character.grandparents).to be_empty
    end

    it 'returns none even grandparent children names match with
      character parent names' do
      create(:character, children: 'Frank Sinatra, Paul Anka')
      create(:character, children: 'Gilda, Meg Ryan')
      character = create(:character, father_name: 'Frank Sinatra', mother_name: 'Gilda')

      expect(character.grandparents.class).to be Character::ActiveRecord_Relation
      expect(character.grandparents).to be_empty
    end

    it 'returns an array of grandparents characters' do
      grandfather_character = create(:character)
      grandmother_character = create(:character)
      father_character = create(:character, father_name: grandfather_character.name)
      mother_character = create(:character, mother_name: grandmother_character.name)
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)

      expect(character.grandparents.class).to be Character::ActiveRecord_Relation
      expect(character.grandparents.size).to eq 2
      expect(character.grandparents).to include(grandfather_character)
      expect(character.grandparents).to include(grandmother_character)
    end
  end

  describe 'grandchildren' do
    it 'returns none if character has no children and nobody has declared
      him as parent' do
      character = create(:character, children: '')

      expect(character.grandchildren.class).to be Character::ActiveRecord_Relation
      expect(character.grandchildren).to be_empty
    end

    it 'returns none if character has declared children but they do not exist' do
      character = create(:character, children: 'Fernando Alonso')

      expect(character.grandchildren.class).to be Character::ActiveRecord_Relation
      expect(character.grandchildren).to be_empty
    end

    it 'returns none if character has children with no children' do
      character = create(:character, children: 'Zipi, Zape')
      create(:character, name: 'Zipi', father_name: '', children: '')

      expect(character.grandchildren.class).to be Character::ActiveRecord_Relation
      expect(character.grandchildren).to be_empty
    end

    it 'returns grandchildren' do
      character = create(:character, children: '')
      child = create(:character, father_name: character.name,
                                 children: 'Mazinger, Afrodita, Dr. Hell')
      grandchild1 = create(:character, name: 'Mazinger', father_name: child.name)
      grandchild2 = create(:character, name: 'Afrodita', father_name: child.name)

      expect(character.grandchildren).to include(grandchild1, grandchild2)
    end
  end

  describe 'siblings_characters' do
    it 'returns none if character has no parents' do
      character = create(:character, father_name: '', mother_name: '')

      expect(character.siblings_characters.class).to be Character::ActiveRecord_Relation
      expect(character.siblings_characters).to be_empty
    end

    it 'returns siblings' do
      father_character = create(:character)
      mother_character = create(:character)
      sibling1 = create(:character, father_name: father_character.name)
      sibling2 = create(:character, mother_name: mother_character.name)
      character = create(:character, father_name: father_character.name, mother_name: mother_character.name)

      expect(character.siblings_characters).to include(sibling1, sibling2)
    end
  end

  describe 'uncles_and_aunts' do
    it 'returns none if character has no parents' do
      character = create(:character, father_name: '', mother_name: '')

      expect(character.uncles_and_aunts.class).to be Character::ActiveRecord_Relation
      expect(character.uncles_and_aunts).to be_empty
    end

    it 'returns none if character parents have no siblings' do
      father_character = create(:character, father_name: '', mother_name: '')
      mother_character = create(:character, father_name: '', mother_name: '')
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)

      expect(character.uncles_and_aunts.class).to be Character::ActiveRecord_Relation
      expect(character.uncles_and_aunts).to be_empty
    end

    it 'returns uncles and aunts' do
      grandfather = create(:character)
      grandmother = create(:character)
      uncle = create(:character, father_name: grandfather.name)
      aunt = create(:character, mother_name: grandmother.name)
      father_character = create(:character, father_name: grandfather.name)
      mother_character = create(:character, mother_name: grandmother.name)
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)

      expect(character.uncles_and_aunts).to include(uncle, aunt)
    end
  end

  describe 'cousins' do
    it 'returns none if character has neither uncles nor aunts' do
      grandfather = create(:character)
      grandmother = create(:character)
      father_character = create(:character, father_name: grandfather.name)
      mother_character = create(:character, mother_name: grandmother.name)
      character = create(:character, father_name: father_character.name, mother_name: mother_character.name)

      expect(character.cousins.class).to be Character::ActiveRecord_Relation
      expect(character.cousins).to be_empty
    end

    it 'returns none if character uncles and aunts have no children' do
      grandfather = create(:character)
      grandmother = create(:character)
      uncle = create(:character, father_name: grandfather.name)
      aunt = create(:character, mother_name: grandmother.name)
      father_character = create(:character, father_name: grandfather.name)
      mother_character = create(:character, mother_name: grandmother.name)
      character = create(:character, father_name: father_character.name,
                                     mother_name: mother_character.name)

      expect(character.cousins.class).to be Character::ActiveRecord_Relation
      expect(character.cousins).to be_empty
    end

    it 'returns cousins' do
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

      expect(character.cousins).to include(cousin2, cousin4)
    end
  end
end
