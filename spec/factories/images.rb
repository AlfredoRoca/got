# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  imageable_type :string
#  imageable_id   :integer
#  source         :string
#  caption        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :image do
    character nil
    source { Faker::Internet.url }
    caption { Faker::Lorem.sentence }
  end
end
