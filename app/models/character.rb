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

class Character < ApplicationRecord
  belongs_to :house, inverse_of: :characters
  has_many :images, as: :imageable, inverse_of: :imageable

  has_many :sons_as_father, class_name: 'Character', foreign_key: 'father_id'
  has_many :sons_as_mother, class_name: 'Character', foreign_key: 'mother_id'
  belongs_to :father, class_name: 'Character', optional: true
  belongs_to :mother, class_name: 'Character', optional: true

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  class << self
    def create_with(row)
      return nil unless row
      row_hash = row.to_hash
      attributes = get_attributes_from(row_hash)
      new_character = Character.find_or_initialize_by(name: attributes[:name])
      father_name = attributes.delete(:father)
      mother_name = attributes.delete(:mother)
      new_character.assign_attributes(attributes)
      if (imported = new_character.save)
        new_character.images.build
        new_character.images = get_images_from(row_hash)
        new_character.father_name = father_name
        new_character.mother_name = mother_name
        new_character.establish_parenthood_association
      end

      {
        imported: imported,
        source: row_hash,
        character: imported ? new_character : nil,
        errors: new_character.errors.full_messages
      }
    end

    def get_attributes_from(row)
      seasons = row[:seasons].try(:gsub, ' ', '').try(:split, ',')
      {
        name: row[:name],
        description: row[:description],
        biography: row[:biography],
        personality: row[:personality],
        titles: row[:titles],
        status: row[:status],
        death: row[:death],
        origin: row[:origin],
        allegiance: row[:allegiance],
        religion: row[:religion],
        predecessor: row[:predecessor],
        successor: row[:successor],
        father: row[:father],
        mother: row[:mother],
        spouse: row[:spouse],
        children: row[:children],
        siblings: row[:siblings],
        lovers: row[:lovers],
        culture: row[:culture],
        house_id: House.find_by_name(row[:house]).try(:id),
        appears_in_season_1: seasons.try(:include?, '1'),
        appears_in_season_2: seasons.try(:include?, '2'),
        appears_in_season_3: seasons.try(:include?, '3'),
        appears_in_season_4: seasons.try(:include?, '4'),
        appears_in_season_5: seasons.try(:include?, '5'),
        appears_in_season_6: seasons.try(:include?, '6'),
        appears_in_season_7: seasons.try(:include?, '7'),
        appears_in_season_8: seasons.try(:include?, '8'),
        appears_in_season_9: seasons.try(:include?, '9')
      }
    end

    def get_images_from(row)
      images = []
      (1..8).each do |i|
        src = "image_#{i}_src"
        caption = "image_#{i}_caption"
        next unless row[src.to_sym].present?
        images.push(
          Image.create(src: row[src.to_sym], caption: row[caption.to_sym])
        )
      end
      images
    end

    def establish_parenthood_association_for_all_characters
      results = []
      Character.all.map do |son|
        %w[father mother].each do |parent_role|
          results.push son.search_and_save_parent_with_diagnosis(parent_role)
        end
      end
      results
    end
  end

  def search_and_save_parent_with_diagnosis(parent_role)
    son = self
    son_parent_name = son.send(parent_role + '_name')
    if son_parent_name &&
       (parent_character = Character.find_by(name: son_parent_name))
      son.update("#{parent_role}_id": parent_character.id)
      diagnosis = "##{son['id']}: found character #{parent_role}"
    elsif (possible_parents = Character.where('children like ?',
                                              "%#{son.name}%"))
      diagnosis = "##{son['id']}: #{son.name} parent found indirectly: _
        #{possible_parents.map(&:name).join(', ')}. _
        Change or enter current #{parent_role} name in son's record and _
        rerun this task."
    elsif !son_parent_name.present?
      diagnosis = "##{son['id']}: has no #{parent_role} name and not found _
        in children fields"
    else
      diagnosis = "Parent character named #{son[parent_role]} not found for _
        son #{son['name']}. Check the name spelling. _
        Change #{parent_role} name in son's record and rerun this task."
    end
    { id: son.id, son: son, diagnosis: diagnosis }
  end

  def establish_parenthood_association
    %w[father mother].each do |parent_role|
      parent_name = self.send(parent_role + '_name')
      if (parent_character = Character.find_by(name: parent_name))
        self.update("#{parent_role}_id": parent_character.id)
      end
    end
  end

  def mother_name
    mother.try(:name) || self[:mother]
  end

  def father_name
    father.try(:name) || self[:father]
  end

  def mother_name=(name)
    self[:mother] = name
  end

  def father_name=(name)
    self[:father] = name
  end

  def children_names
    (sons_as_father + sons_as_mother).map(&:name) || self[:children]
  end
end
