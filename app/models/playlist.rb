class Playlist < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :items, :dependent => :destroy
  has_many :songs, :through => :items
  
  def apply_to_amarok
    Amarok::Player.stop
    username = Dir.pwd.split('/')[2]
    Amarok::Playlist.clearPlaylist
    self.items.reverse.each do |item|
      Amarok::Playlist.addMedia("/home/"+username+"/apps/jukeman/public/system/songs/"+item.song.id.to_s+"/original/"+item.song.song_file_name)
    end
    Amarok::Player.enableRepeatPlaylist(true)
    Amarok::Player.play
  end
  

  class << self
    
    def active
      location = Location.find_by_name(APP_CONFIG[:location])
      return Playlist.find_by_name(location.active_playlist)
    end
    
    def rename(old_name, new_name)
      Playlist.find_by_name(old_name).update_attributes(:name => new_name)
    end

    def remove(name)
      Playlist.find_by_name(name).destroy
    end

    def add_song(playlist_name, song_uuid)
      playlist_id = Playlist.find_by_name(playlist_name).id
      Item.create(:playlist_id => playlist_id, :song_id => Song.find_by_uuid(song_uuid).id, :ordinal => Item.count(:conditions => {:playlist_id => playlist_id})+1)
    end

    def remove_item_by_ordinal(playlist_name, ordinal)
      playlist_id = Playlist.find_by_name(playlist_name).id
      Item.find(:first, :conditions => {:playlist_id => playlist_id, :ordinal => ordinal}).destroy
      Item.find(:all, :conditions => ["playlist_id = ? AND ordinal > ?", playlist_id, ordinal]).each do |item|
        item.update_attributes(:ordinal => item.ordinal - 1)
      end
    end
    
    def reorder(playlist_name, ordinals)
      Item.ordinal_shift(playlist_name, ordinals)
    end

  end

end
