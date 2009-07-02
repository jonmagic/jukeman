require 'lib/uuid'

class Song < ActiveRecord::Base
  
  has_many :items, :dependent => :destroy
  has_many :playlists, :through => :items

  has_attached_file :song
  
  validates_attachment_presence :song
  validates_attachment_size :song, :less_than => 200.megabytes, :message => "File is too large."
  
  attr_protected :name, :artist, :album, :genre, :duration
  
  before_create :add_uuid
  
  GENRES = ['Blues', 'Classic Rock',
      'Country', 'Dance', 'Disco', 'Funk', 'Grunge', 'Hip-Hop',
      'Jazz', 'Metal', 'New Age', 'Oldies', 'Other', 'Pop', 'R&B',
      'Rap', 'Reggae', 'Rock', 'Techno', 'Industrial', 'Alternative',
      'Ska', 'Death Metal', 'Pranks', 'Soundtrack', 'Euro-Techno',
      'Ambient', 'Trip-Hop', 'Vocal', 'Jazz+Funk', 'Fusion', 'Trance',
      'Classical', 'Instrumental', 'Acid', 'House', 'Game', 'Sound Clip',
      'Gospel', 'Noise', 'AlternRock', 'Bass', 'Soul', 'Punk',
      'Space', 'Meditative', 'Instrumental Pop', 'Instrumental Rock',
      'Ethnic', 'Gothic', 'Darkwave', 'Techno-Industrial', 'Electronic',
      'Pop-Folk', 'Eurodance', 'Dream', 'Southern Rock', 'Comedy',
      'Cult', 'Gangsta', 'Top 40', 'Christian Rap', 'Pop/Funk',
      'Jungle', 'Native American', 'Cabaret', 'New Wave', 'Psychadelic',
      'Rave', 'Showtunes', 'Trailer', 'Lo-Fi', 'Tribal', 'Acid Punk',
      'Acid Jazz', 'Polka', 'Retro', 'Musical', 'Rock & Roll',
      'Hard Rock', 'Folk', 'Folk-Rock', 'National Folk', 'Swing',
      'Fast Fusion', 'Bebob', 'Latin', 'Revival', 'Celtic', 'Bluegrass',
      'Avantgarde', 'Gothic Rock', 'Progressive Rock', 'Psychedelic Rock',
      'Symphonic Rock', 'Slow Rock', 'Big Band', 'Chorus', 'Easy Listening',
      'Acoustic', 'Humour', 'Speech', 'Chanson', 'Opera', 'Chamber Music',
      'Sonata', 'Symphony', 'Booty Bass', 'Primus', 'Porn Groove',
      'Satire', 'Slow Jam', 'Club', 'Tango', 'Samba', 'Folklore',
      'Ballad', 'Power Ballad', 'Rhythmic Soul', 'Freestyle', 'Duet',
      'Punk Rock', 'Drum Solo', 'Acapella', 'Euro-House', 'Dance Hall']
  
  def url
    'http://' + APP_CONFIG[:domain] + relative_url
  end
  def relative_url
    "/system/songs/"+self.id.to_s+"/original/"+self.song_file_name
  end

  def read_id3_tags
    path = RAILS_ROOT + '/public' + relative_url
    Mp3Info.open(path) do |song|
      self.name     = song.tag.title
      self.artist   = song.tag.artist
      self.duration = song.length
      self.album    = song.tag.album
      if song.tag.genre && (1..125) === song.tag.genre.to_i
        self.genre = GENRES[song.tag.genre.to_i]
      elsif song.tag.genre_s && (1..125) === song.tag.genre_s.gsub(/\D/,'').to_i
        self.genre = GENRES[song.tag.genre_s.gsub(/\D/,'').to_i]
      else
        self.genre = ""
      end
    end
  end
  
  def add_uuid
    uuid = UUID.new
    self.uuid = uuid.generate
  end
  
  def time
    if self.duration
      minutes = (self.duration/60).to_i
      seconds = (((self.duration/60 - minutes)/100)*60*100).round
      return minutes.to_s + ":" + ('%.02d' % seconds)
    else
      ""
    end
  end
  
  class << self
    def download(url)
      # Create Song record
      # Download to: [RAILS_ROOT]/public/system/songs/[id]/original/[filename]
      # Save file info:
      #   song.song_file_name (leaf-name)
      #   song_content_type
      #   song_file_size
      #   song_updated_at
    end
    
    def remove(uuid)
      Song.find_by_uuid(uuid).destroy
    end   
  end
end
