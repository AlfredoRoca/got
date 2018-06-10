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

class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true, inverse_of: :images

  alias_attribute :src, :source
end
