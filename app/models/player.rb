require 'librmpd'

class Player
  
  def self.play
    with_mpd do |mpd|
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
