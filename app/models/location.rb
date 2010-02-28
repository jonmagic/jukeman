require 'httparty'

class Location
  include HTTParty  
  include MongoMapper::Document
  
  key :name, String, :unique => true, :required => true
  key :ip, String, :unique => true, :required => true
  key :playlist_id, ObjectId
  
  has_one :playlist
  
  def activate_playlist(playlist_id)
    if self.update_attributes(:playlist_id => playlist_id)
      Player.clear
      Playlist.find(self.playlist_id).load
      Player.play
    end
  end
  
  def self.startup
    if @location = Location.first(:name => APP_CONFIG[:location])
      Player.clear
      Playlist.find(@location.playlist_id).load
      Player.play
    end
  end
  
  def get_status
    Crack::JSON.parse(self.class.get("http://#{self.ip}:3333/player"))
  end
  
  def update_player(parameters)
    self.class.post("http://#{self.ip}:3333/player?"+parameters)
  end

end