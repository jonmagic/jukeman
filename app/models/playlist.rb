class Playlist < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :items, :dependent => :destroy
  has_many :songs, :through => :items

  class << self
    def rename(old_name, new_name)
      Playlist.find_by_name(old_name).update_attributes(:name => new_name)
    end

    def remove(name)
      Playlist.find_by_name(name).destroy
    end

    def add_song(playlist_name, song_uuid)
      Item.create(:playlist_id => Playlist.find_by_name(playlist_name).id, :song_id => Song.find_by_uuid(song_uuid).id)
    end
    
    def reorder_items(playlist)
      playlist = Playlist.find_by_name(playlist)
      items = Item.find(:all, :conditions => {:playlist_id => playlist.id}, :order => 'ordinal ASC')
      counter = 1
      items.each do |item|
        item.update_attributes(:ordinal => counter)
        counter += 1
      end
    end
  end

end
