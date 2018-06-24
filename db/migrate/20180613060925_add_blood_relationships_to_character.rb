class AddBloodRelationshipsToCharacter < ActiveRecord::Migration[5.0]
  def change
    add_reference :characters, :father, index: true
    add_reference :characters, :mother, index: true
  end
end
