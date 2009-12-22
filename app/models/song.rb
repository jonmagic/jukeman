require 'uuid'
require 'uri'
require 'cgi'
require 'httparty'
require 'ftools'

class Song
  include MongoMapper::Document
  include Grip
  
  has_grid_attachment :mp3

  key :name, String, :require => true
  key :album, String
  key :artist, String
  key :genre, 


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
  
  def read_id3_tags
    begin
      Mp3Info.open(full_filename) do |song|
        song.tag.title.blank? ? self.name = song_file_name : self.name = song.tag.title
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
    rescue
      self.name = song_file_name
    end
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
    
    def import_from_folder
      files = Dir[APP_CONFIG[:import_folder_path]+"/*.mp3"]
      songs = []
      songs_imported = 0
      Song.all.each do |song|
        songs << song.song_file_name
      end
      files.each do |file|
        filename = file.split('/')[-1]
        if !songs.include?(filename)
          song = Song.new
          song.save_without_validation
          begin
            song.song_file_name = filename
            path = song.full_filename[0..-1-filename.length]
            File.makedirs(path)
            File.copy(file, path+song.song_file_name)
            mp3 = File.open(path+song.song_file_name, "r")
            song.song_file_size = mp3.size
            mp3.close
            # Save file info
            song.read_id3_tags
            song.save_without_validation
            Journal.add_song(song.relative_url, song.uuid)
            songs_imported += 1
          rescue
            song.destroy
          end
        end 
      end
      return songs_imported
    end
      
  end
end
