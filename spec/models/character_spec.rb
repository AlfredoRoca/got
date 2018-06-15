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
end
