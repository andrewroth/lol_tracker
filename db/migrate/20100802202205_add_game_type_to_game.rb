class AddGameTypeToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :game_type, :string
  end

  def self.down
    remove_column :games, :game_type
  end
end
