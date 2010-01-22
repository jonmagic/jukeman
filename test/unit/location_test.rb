require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < ActiveSupport::TestCase
  context "locations" do
    setup do
      @playlist = Playlist.create(:name => 'Sample Playlist')
    end

    should "be able to save if valid" do
      assert Location.create(:name => 'Angola', :playlist_id => Playlist.first.id)
    end
    
    should "fail to save when not valid" do
      l = Location.new(:playlist_id => Playlist.first.id)
      assert_equal false, l.save
    end
    
    should "fail if playlist_id is not an ObjectId" do
      assert_raise Mongo::InvalidObjectID do
        Location.create(:name => 'Angola', :playlist_id => '4284818')
      end
    end
  end
  
end
