class CreateHouses < ActiveRecord::Migration[5.0]
  def change
    create_table :houses do |t|
      t.string :name
      t.string :description
      t.string :background
      t.string :words
      t.string :seat
      t.string :region
      t.string :lord
      t.string :religion
      t.string :sigil_url
      t.string :sigil

      t.timestamps
    end
  end
end
