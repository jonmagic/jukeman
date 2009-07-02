require 'httparty'
require 'uri'
class Journal < ActiveRecord::Base
  class Downloader
    include HTTParty
  end

  class << self
    def record(command)
      Journal.create(:command => command)
    end

    def from_server
      location = Location.find(:first, :conditions => {:name => APP_CONFIG[:location]})
      url = 'http://' + APP_CONFIG[:jukeman_server] + '/journals.json'
      journals = if location.polled_at.nil?
        Journal::Downloader.get(url)
      else
        Journal::Downloader.get(url, :query => {:since => location.polled_at})
      end
      journals.each do |journal|
        Journal.run(journal['journal']['command'])
      end
    end

    # SONGS
    def add_song(url, uuid)
      # NOT .run - already have the song!
      Journal.record("Song.download(#{url.inspect}, #{uuid.inspect})")
    end
    
    def remove_song(uuid)
      Journal.run("Song.remove(#{uuid.inspect})")
    end
    

    # PLAYLISTS
    def new_playlist(name)
      Journal.run("Playlist.create(:name => #{name.inspect})")
    end

    def rename_playlist(old_name, new_name)
      Journal.run("Playlist.rename(#{old_name.inspect}, #{new_name.inspect})")
    end

    def remove_playlist(playlist_name)
      Journal.run("Playlist.remove(#{playlist_name.inspect})")
    end

    def reorder_playlist(playlist_name, ordinals)
      Journal.run("Playlist.reorder(#{playlist_name.inspect}, #{ordinals.inspect})")
    end
    
    
    # ITEMS
    def add_playlist_item(playlist_name, song_uuid)
      Journal.run("Playlist.add_song(#{playlist_name.inspect}, #{song_uuid.inspect})")
    end
    
    def remove_playlist_item_by_ordinal(playlist_name, item_ordinal)
      Journal.run("Playlist.remove_item_by_ordinal(#{playlist_name.inspect}, #{item_ordinal.inspect})")
    end
    
    # LOCATIONS
    def new_location(location_name, active_playlist)
      Journal.run("Location.create(:name => #{location_name.inspect}, :active_playlist => #{active_playlist.inspect})")
    end
    
    def edit_location(previous_name, new_name, active_playlist)
      Journal.run("Location.edit_location(#{previous_name.inspect}, #{new_name.inspect}, #{active_playlist.inspect})")
    end
    
    def remove_location(location_name)
      Journal.run("Location.remove(#{location_name.inspect})")
    end
    
    def run(command)
      # Run the command, then Journal it ourselves! If we want to daisy-chain these, it should work well this way...
      eval(command) && Journal.run(command)
    end
  end

  def apply
    Journal.run(command)
  end
end
