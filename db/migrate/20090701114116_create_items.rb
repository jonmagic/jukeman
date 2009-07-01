class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :playlist_id
      t.integer :song_id
      t.integer :ordinal
    end
  end

  def self.down
    drop_table :items
  end
end
