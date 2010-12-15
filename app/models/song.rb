require "ftools"

class Song
  include MongoMapper::Document
  mount_uploader :mp3, Mp3Uploader

  key :title, String
  key :artist, String
  key :album, String
  key :genre, String
  key :duration, Float
  key :destroyed_at, Time

  before_validation_on_create :set_id3_tags
  def set_id3_tags
    tags  = Song.read_id3_tags(self.mp3.file.file)
    self.title, self.artist, self.album, self.genre, self.duration = tags["title"], tags["artist"], tags["album"], tags["genre"], tags["duration"]
    # self.title = self.mp3_name if self.title.include?("RackMultipart")
  end
  validate_on_create :unique_song
  def unique_song
    if existing = Song.first(:title => self.title, :duration => self.duration)
      existing.destroyed_at = nil
      existing.save
      self.errors.add :mp3, "song already exists!"
    end
  end

  alias :destroy_song :destroy
  def destroy
    update_attributes(:destroyed_at => Time.zone.now) unless destroyed_at?
    Playlist.all.each do |playlist|
      playlist.songs.delete(id.to_s)
      playlist.save
    end
  end

  def self.import_song(file_path)
    mp3   = File.open(file_path, 'r')
    tags  = Song.read_id3_tags(file_path)
    song  = Song.new(:mp3 => mp3, :title => tags["title"], :artist => tags["artist"], :album => tags["album"], :genre => tags["genre"], :duration => tags["duration"])
    song.save
  end

  def self.import_from_folder(folder=APP_CONFIG[:import_folder_path])
    file_paths = Dir[folder+"/*.mp3"]
    songs, songs_imported = [], 0
    Song.all.each { |song| songs << song.title+".mp3" }
    file_paths.each do |file_path|
      filename = file_path.split('/')[-1]
      if !songs.include?(filename)
        if Song.import_song(file_path)
          songs_imported += 1
          Rails.logger.info "Imported song #{filename}"
        end
      end
    end
    return songs_imported
  end

  def self.read_id3_tags(file_path)
    tags = {}
    begin
      Mp3Info.open(file_path) do |song|
        tags["title"]     = song.tag.title.blank?   ? file_path.split('/')[-1].make_utf8 : song.tag.title.make_utf8
        tags["artist"]    = song.tag.artist.blank?  ? nil                      : song.tag.artist.make_utf8
        tags["duration"]  = song.length.blank?      ? nil                      : song.length
        tags["album"]     = song.tag.album.blank?   ? nil                      : song.tag.album.make_utf8
        if song.tag.genre && (1..125).include?(song.tag.genre.to_i)
          tags["genre"] = GENRES[song.tag.genre.to_i]
        elsif song.tag.genre_s && (1..125).include?(song.tag.genre_s.gsub(/\D/,'').to_i)
          tags["genre"] = GENRES[song.tag.genre_s.gsub(/\D/,'').to_i]
        else
          tags["genre"] = nil
        end
      end
    rescue
      tags["title"] = file_path.split('/')[-1].make_utf8
    end
    return tags
  end

  GENRES = [
    'Blues', 'Classic Rock',
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

  def self.genres
    GENRES
  end

  def genre_name
    unless self.genre.blank?
      index = self.genre.to_i - 1
      GENRES[index]
    else
      ""
    end
  end

  def duration_converted
    minutes = (duration/60).to_i
    seconds = (((duration/60 - minutes)/100)*60*100).round
    return "#{minutes}:#{seconds}"
  end

end

class String
  def make_utf8
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    ic.iconv(self + ' ')[0..-2]
  end
end