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

require 'rails_helper'

RSpec.describe House, type: :model do
end
