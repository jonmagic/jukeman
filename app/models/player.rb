require 'librmpd'

class Player
  
  def self.state
    with_mpd do |mpd|
      state = mpd.status["state"]
    end
  end
  
  def self.current_song
    with_mpd do |mpd|
      mpd.current_song.blank? ? '' : Song.find(mpd.current_song["file"].split("/")[-1]).title
    end
  end
  
  def self.play
    with_mpd do |mpd|
      mpd.repeat = 1
      mpd.crossfade = 2
      mpd.play
    end
  end
  
  def self.next_song
    with_mpd do |mpd|
      mpd.next
    end
  end
  
  def self.previous_song
    with_mpd do |mpd|
      mpd.previous
    end
  end
  
  def self.stop
    with_mpd do |mpd|
      mpd.stop
    end
  end

  def self.clear
    with_mpd do |mpd|
      mpd.clear
    end
  end

  def self.with_mpd(&block)
    mpd = MPD.new 'localhost', APP_CONFIG[:mpd_port]
    mpd.connect
    if mpd.connected?
      yield(mpd)
    end
  ensure
    mpd.disconnect
  end
  
end

# http://192.168.2.1:3333/gridfs/song/mp3/4b855401e5947c989d000001