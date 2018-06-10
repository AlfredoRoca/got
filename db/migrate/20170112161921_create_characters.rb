class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.references :house, foreign_key: true
      t.string :description
      t.string :biography
      t.string :personality
      t.string :titles
      t.string :status
      t.string :death
      t.string :origin
      t.string :allegiance
      t.string :religion
      t.string :predecessor
      t.string :successor
      t.string :father
      t.string :mother
      t.string :spouse
      t.string :children
      t.string :siblings
      t.string :lovers
      t.string :culture
      t.boolean :appears_in_season_1
      t.boolean :appears_in_season_2
      t.boolean :appears_in_season_3
      t.boolean :appears_in_season_4
      t.boolean :appears_in_season_5
      t.boolean :appears_in_season_6
      t.boolean :appears_in_season_7
      t.boolean :appears_in_season_8
      t.boolean :appears_in_season_9

      t.timestamps
    end
  end
end
