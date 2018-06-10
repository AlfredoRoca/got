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

FactoryGirl.define do
  factory :character do
    name { Faker::GameOfThrones.character }
    description  { Faker::Lorem.paragraphs.join("\n") }
    biography  { Faker::Lorem.paragraphs.join("\n") }
    personality  { Faker::Lorem.paragraphs.join("\n") }
    titles { Faker::Lorem.sentence }
    status "Death"
    death { Faker::Lorem.sentence }
    origin { Faker::GameOfThrones.city }
    allegiance { Faker::GameOfThrones.house }
    religion { Faker::Lorem.sentence }
    predecessor { Faker::GameOfThrones.character }
    successor { Faker::GameOfThrones.character }
    father { Faker::GameOfThrones.character }
    mother { Faker::GameOfThrones.character }
    spouse { Faker::GameOfThrones.character }
    children { Faker::GameOfThrones.character }
    siblings { Faker::GameOfThrones.character }
    lovers { Faker::GameOfThrones.character }
    culture { Faker::Lorem.word }
    appears_in_season_1 { [true, false].sample }
    appears_in_season_2 { [true, false].sample }
    appears_in_season_3 { [true, false].sample }
    appears_in_season_4 { [true, false].sample }
    appears_in_season_5 { [true, false].sample }
    appears_in_season_6 { [true, false].sample }
    appears_in_season_7 { [true, false].sample }
    appears_in_season_8 { [true, false].sample }
    appears_in_season_9 { [true, false].sample }
  end
end
