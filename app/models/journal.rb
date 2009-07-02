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

    def import_from_server(datetime=nil)
      location = Location.find(:first, :conditions => {:name => APP_CONFIG[:location]})
      url = 'http://' + APP_CONFIG[:jukeman_server] + '/journals.json'
      datetime ||= location.polled_at if location.nil? || location.polled_at.nil?
      journals = if datetime
        Journal::Downloader.get(url, :query => {:since => Date.parse(datetime).strftime("%Y-%m-%d")})
      else
        Journal::Downloader.get(url)
      end
      journals.each do |journal|
        if Journal.run(journal['journal']['command']) && location = Location.find(:first, :conditions => {:name => APP_CONFIG[:location]})
          location.update_attributes(:polled_at => journal['journal']['created_at'])
        end
      end
    end

    # SONGS
    def add_song(url, uuid)
      # NOT Journal.run - we already have the song!
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
      puts "Journal Apply: #{command}"
      eval(command) && (Journal.record(command) unless command =~ /^Song.download/)
    end
  end

  def apply
    Journal.run(command)
  end
end
