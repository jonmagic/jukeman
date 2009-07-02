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
      Item.create(:playlist_id => Playlist.find_by_name(playlist_name).id, :song_id => Song.find_by_uuid(song_uuid).id, :ordinal => Item.count(:conditions => {:playlist_id => playlist.id})+1)
    end

    def remove_item_by_ordinal(playlist_name, ordinal)
      playlist_id = Playlist.find_by_name(playlist_name).id
      Item.find(:first, :conditions => {:playlist_id => playlist_id, :ordinal => ordinal})
      Item.find(:all, :conditions => ["playlist_id = ? AND ordinal > ?", playlist_id, ordinal]}).each do |item|
        item.update_attributes(:ordinal => item.ordinal - 1)
      end
    end
    
    def reorder(playlist_name, ordinals)
      Item.ordinal_shift(playlist_name, ordinals)
    end

  end

end
