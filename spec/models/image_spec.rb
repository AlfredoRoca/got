# frozen_string_literal: true

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

require 'rails_helper'

RSpec.describe Image, type: :model do
end
