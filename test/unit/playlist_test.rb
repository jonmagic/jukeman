require File.dirname(__FILE__) + '/../test_helper'


class PlaylistTest < ActiveSupport::TestCase
  context "playlists" do
    setup do
      Song.import_from_folder
    end

    should "store song ids" do
      playlist = Playlist.new(:name => "Test Playlist")
      playlist.songs = Song.all.collect { |s| s.id }
      playlist.save
      assert_equal 2, playlist.songs.length
    end
  end
  
  # context "when loading a playlist it" do
  #   def setup
  #     Song.import_from_folder
  #     @playlist = Playlist.new(:name => "Test Playlist")
  #     @playlist.songs = Song.all.collect { |s| s.id }
  #     @playlist.save
  #   end
  # 
  #   should "load the playlist to mpd" do
  #     @playlist.load
  #     assert @mpd.playlist
  #   end
  # end
  
  
end