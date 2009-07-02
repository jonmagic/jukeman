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
      Song.remove(uuid) &&
        Journal.record("Song.remove(#{uuid.inspect})")
    end
    

    # PLAYLISTS
    def new_playlist(name)
      Playlist.create(:name => name) &&
        Journal.record("Playlist.create(:name => #{name.inspect})")
    end

    def rename_playlist(old_name, new_name)
      Playlist.rename(old_name, new_name) &&
        Journal.record("Playlist.rename(#{old_name.inspect}, #{new_name.inspect})")
    end

    def remove_playlist(playlist_name)
      Playlist.remove(playlist_name) &&
        Journal.record("Playlist.remove(#{playlist_name.inspect})")
    end

    def reorder_playlist(playlist_name, ordinals)
      Playlist.reorder(playlist_name, ordinals) &&
        Journal.record("Playlist.reorder(#{playlist_name.inspect}, #{ordinals.inspect})")
    end
    
    
    # ITEMS
    def add_playlist_item(playlist_name, song_uuid)
      Playlist.add_song(playlist_name, song_uuid) &&
        Journal.record("Playlist.add_song(#{playlist_name.inspect}, #{song_uuid.inspect})")
    end
    
    def remove_playlist_item_by_ordinal(playlist_name, item_ordinal)
      Playlist.remove_item_by_ordinal(playlist_name, item_ordinal) &&
        Journal.record("Playlist.remove_item_by_ordinal(#{playlist_name.inspect}, #{item_ordinal.inspect})")
    end
    
    # LOCATIONS
    def new_location(location_name, active_playlist)
      Location.create(:name => location_name, :active_playlist => active_playlist) &&
        Journal.record("Location.create(:name => #{location_name.inspect}, :active_playlist => #{active_playlist.inspect})")
    end
    
    def edit_location(previous_name, new_name, active_playlist)
      Location.edit_location(previous_name, new_name, active_playlist) &&
        Journal.record("Location.edit_location(#{previous_name.inspect}, #{new_name.inspect}, #{active_playlist.inspect})")
    end
    
    def remove_location(location_name)
      Location.remove(location_name) &&
        Journal.record("Location.remove(#{location_name.inspect})")
    end
    
    
  end

  def apply
    eval(command)
  end
end
