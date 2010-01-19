class Song
  include MongoMapper::Document
  include Grip
  
  has_grid_attachment :mp3

  key :title, String, :require => true
  key :artist, String
  key :album, String
  key :genre, String
  key :duration, Float
  key :destroyed_at, Time
  
  alias :destroy_song :destroy
  
  def destroy
    update_attributes(:destroyed_at => Time.zone.now) unless destroyed_at?
  end
  
  def self.import_song(file_path)
    mp3   = File.open(file_path, 'r')
    tags  = Song.read_id3_tags(file_path)
    song  = Song.create(:mp3 => mp3, :title => tags["title"], :artist => tags["artist"], :album => tags["album"], :genre => tags["genre"], :duration => tags["duration"])
  end
  
  def self.import_from_folder
    file_paths = Dir[APP_CONFIG[:import_folder_path]+"/*.mp3"]
    songs, songs_imported = [], 0
    Song.all.each { |song| songs << song.mp3_name }
    file_paths.each do |file_path|
      filename = file_path.split('/')[-1]
      if !songs.include?(filename)
        songs_imported += 1 if Song.import_song(file_path)
      end 
    end
    return songs_imported
  end

  def self.read_id3_tags(file_path)
    tags = {}
    begin
      Mp3Info.open(file_path) do |song|
        tags["title"]     = song.tag.title.blank?   ? file_path.split('/')[-1] : song.tag.title
        tags["artist"]    = song.tag.artist.blank?  ? nil                      : song.tag.artist
        tags["duration"]  = song.length.blank?      ? nil                      : song.length
        tags["album"]     = song.tag.album.blank?   ? nil                      : song.tag.album
        if song.tag.genre && (1..125).include?(song.tag.genre.to_i)
          tags["genre"] = GENRES[song.tag.genre.to_i]
        elsif song.tag.genre_s && (1..125).include?(song.tag.genre_s.gsub(/\D/,'').to_i)
          tags["genre"] = GENRES[song.tag.genre_s.gsub(/\D/,'').to_i]
        else
          tags["genre"] = nil
        end
      end
    rescue
      tags["title"] = file_path.split('/')[-1]
    end
    return tags
  end

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
    
  def duration_converted
    total_minutes           = duration / 1.minutes
    seconds_in_last_minute  = duration - total_minutes.minutes.seconds
    return "#{total_minutes}:#{seconds_in_last_minute}"
  end
  
end