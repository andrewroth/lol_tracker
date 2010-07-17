class CreateChampions < ActiveRecord::Migration
  def self.up
    create_table :champions do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :champions
  end
end
