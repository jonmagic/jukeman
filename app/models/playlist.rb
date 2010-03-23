require 'librmpd'

class Playlist
  include MongoMapper::Document
  key :name, String, :require => true, :unique => true
  key :songs, Array
  key :destroyed_at, Time
  
  attr_accessor :items
  before_save :items_to_array
  def items_to_array
    return if items.blank?
    self.songs = items.split(',')
  end
  
  alias :destroy_playlist :destroy
  def destroy
    update_attributes(:destroyed_at => Time.zone.now) unless destroyed_at?
  end
  
  def load
    with_mpd do |mpd|
      songs.each { |id| mpd.add "http://localhost:3333/gridfs/#{Song.find(id).mp3_id.to_s}" }
    end
  end

  def with_mpd(&block)
    mpd = MPD.new 'localhost', APP_CONFIG[:mpd_port]
    mpd.connect
    if mpd.connected?
      yield(mpd)
    end
  ensure
    mpd.disconnect
  end
  
end
