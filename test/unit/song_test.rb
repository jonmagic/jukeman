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
    setup do
      Song.import_from_folder
    end

    should "import all songs in the folder" do
      assert_equal Song.count, 2
    end
  end
  
  
end