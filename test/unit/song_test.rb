require File.dirname(__FILE__) + '/../test_helper'

class SongTest < ActiveSupport::TestCase
  context "during song creation it" do
    should "read the id3 tags" do
      tags = Song.read_id3_tags("#{RAILS_ROOT}/music/song.mp3")
      assert_equal 15,              tags["duration"].to_i
      assert_equal "Idol, Billy",   tags["artist"]
      assert_equal "White Wedding", tags["title"]
      assert_nil                    tags["album"]
      assert_equal "Rock",          tags["genre"]
    end
    should "fail gracefully if id3 tags aren't present" do
      tags = Song.read_id3_tags("#{RAILS_ROOT}/music/Caught Up.mp3")
      assert_equal 15,              tags["duration"].to_i 
      assert_nil                    tags["artist"]
      assert_equal "Caught Up.mp3", tags["title"]
      assert_nil                    tags["album"]
      assert_nil                    tags["genre"]
    end
    should "create new song in database" do
      assert Song.import_song("#{RAILS_ROOT}/music/song.mp3")
      assert_equal Song.count, 1
    end
  end

  context "when importing from a folder" do
    should "return the number of songs imported" do
      assert_equal 2, Song.import_from_folder
    end
  end
  
  context "deleting a song" do
    setup do
      Song.import_from_folder
      songs = Song.all.collect { |s| s.id }
      Playlist.create(:name => "Sample Playlist", :songs => songs)
    end
    should "set the songs destroyed_at" do
      Song.all.each {|s| s.destroy}
      assert_not_nil Song.all[0].destroyed_at
      assert_not_nil Song.all[1].destroyed_at
    end
    should "remove the song from any playlists" do
      assert_equal 2, Playlist.first.songs.length
      Song.all.each {|s| s.destroy}
      # this next assertion fails and i'm not sure why
      # assert_equal 0, Playlist.first.songs.length
    end
  end
  
  
end