class CreateGameBans < ActiveRecord::Migration
  def self.up
    create_table :game_bans do |t|
      t.integer :champion_id
      t.integer :game_id

      t.timestamps
    end
  end

  def self.down
    drop_table :game_bans
  end
end
