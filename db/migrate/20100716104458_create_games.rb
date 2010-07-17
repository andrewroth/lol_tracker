class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :game_id
      t.text :notes
      t.boolean :win
      t.datetime :played_at

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
