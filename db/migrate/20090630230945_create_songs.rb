class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :uuid
      t.string :name
      t.float :duration
      t.string :artist
      t.string :album
      t.string :genre
      
      t.deletestamps(false)

      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
