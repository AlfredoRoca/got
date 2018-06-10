# frozen_string_literal: true

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
  context 'validation' do
    let(:house) { build(:house) }

    it 'rejects without name', :aggregate_failures do
      house.name = nil
      expect(house.valid?).to be false
      expect(house.errors.messages.include?(:name)).to be true
    end

    it 'rejects if name exists', :aggregate_failures do
      some_house = create(:house)
      house.name = some_house.name
      expect(house.valid?).to be false
      expect(house.errors.messages.include?(:name)).to be true
    end

    it 'rejects without description' do
      house.description = nil
      expect(house.valid?).to be false
      expect(house.errors.messages.include?(:description)).to be true
    end

    it 'rejects without sigil_url', :aggregate_failures do
      house.sigil_url = nil
      expect(house.valid?).to be false
      expect(house.errors.messages.include?(:sigil_url)).to be true
    end

    it 'accepts with name, description and sigil_url', :aggregate_failures do
      expect(house.valid?).to be true
    end
  end
end
