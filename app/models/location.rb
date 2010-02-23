class Location
  include MongoMapper::Document
  
  key :name, String, :unique => true, :required => true
  key :playlist_id, ObjectId
  
  has_one :playlist
  # has_many :actions
  
  def self.load_playlist(playlist_id=nil)
    if playlist_id.blank?
      if l = Location.find_by_name(APP_CONFIG[:location])
        playlist = Playlist.find(l.playlist_id)
        playlist.load
      end
    else
      playlist = Playlist.find(playlist_id)
      playlist.load
    end
  end
  
end