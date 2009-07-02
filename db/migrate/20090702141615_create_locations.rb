class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.datetime :polled_at
      t.string :active_playlist

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
