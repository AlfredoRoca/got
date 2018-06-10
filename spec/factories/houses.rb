# == Schema Information
#
# Table name: houses
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  background  :string
#  words       :string
#  seat        :string
#  region      :string
#  lord        :string
#  religion    :string
#  sigil_url   :string
#  sigil       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :house do
    name { Faker::GameOfThrones.house }
    description { Faker::Lorem.paragraphs.join("\n") }
    background { Faker::Lorem.paragraphs.join("\n") }
    words { Faker::Lorem.sentence }
    seat { Faker::GameOfThrones.city }
    region { Faker::Lorem.sentence }
    lord { Faker::GameOfThrones.character }
    religion { Faker::Lorem.sentence }
    sigil_url { Faker::Internet.url }
    sigil { Faker::Lorem.sentence }
  end
end
