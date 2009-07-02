class Journal < ActiveRecord::Base
  class << self
    def record(command)
      Journal.create(:command => command)
    end

    # SONGS
    def add_song(url, uuid)
      Journal.record("Song.download(#{url.inspect}, #{uuid.inspect})")
    end
    
    def remove_song(uuid)
      if Song.remove(uuid)
        Journal.record("Song.remove(#{uuid.inspect})")
      else
        nil
      end
    end
    

    # PLAYLISTS
    def new_playlist(name)
      if @playlist = Playlist.create(:name => name)
        Journal.record("Playlist.create(#{name.inspect})")
        return @playlist
      else
        nil
      end
    end

    def rename_playlist(old_name, new_name)
      if Playlist.rename(old_name, new_name)
        Journal.record("Playlist.rename(#{old_name.inspect}, #{new_name.inspect})")
      else
        nil
      end
    end

    def remove_playlist(playlist_name)
      if Playlist.remove(playlist_name)
        Journal.record("Playlist.remove(#{playlist_name.inspect})")
      else
        nil
      end
    end

    def add_song_to_playlist_and_reorder(playlist_name, song_uuid)
      if Playlist.add_song(playlist_name, song_uuid) && Playlist.reorder_items(playlist_name)
        Journal.record("Playlist.add_song(#{playlist_name.inspect}, #{song_uuid.inspect})")
        Journal.record("Playlist.reorder_items(#{playlist_name.inspect})")
      else
        nil
      end
    end
    
    def reorder_playlist(playlist_name, ordinals)
      if Item.ordinal_shift(playlist_name, ordinals)
        Journal.record("Item.ordinal_shift(#{playlist_name.inspect}, #{ordinals.inspect})")
      else
        nil
      end
    end
    
    
    # ITEMS
    def remove_item_and_reorder_playlist(playlist_name, item_ordinal)
      if Item.remove(playlist_name, item_ordinal) && Playlist.reorder_items(playlist_name)
        Journal.record("Item.remove(#{playlist_name.inspect}, #{item_ordinal.inspect})")
        Journal.record("Playlist.reorder_items(#{playlist_name.inspect})")
      else
        nil
      end
    end
    
  end

  def apply
    eval(command)
  end
end
