class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :user_movement
      t.integer :bot_movement
      t.integer :winner

      t.timestamps
    end
  end
end
