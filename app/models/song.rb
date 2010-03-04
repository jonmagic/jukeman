class Song
  include MongoMapper::Document
  include Grip
  
  has_grid_attachment :mp3

  key :title, String
  key :artist, String
  key :album, String
  key :genre, String
  key :duration, Float
  key :destroyed_at, Time

  def self.save(upload)
    song = Song.new(upload)
    song.mp3_name = upload[:mp3].original_filename
    tags  = Song.read_id3_tags(upload[:mp3].path)
    if existing = Song.first(:title => tags["title"], :duration => tags["duration"])
      existing.destroyed_at = nil
      existing.save
      Rails.logger.info "### found existing ###"
    else
      song.title, song.artist, song.album, song.genre, song.duration = tags["title"], tags["artist"], tags["album"], tags["genre"], tags["duration"]
      song.title = song.mp3_name if song.title.include?("RackMultipart")
      song.save
      Rails.logger.info "### put tags on new ###"
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
    Song.create(:mp3 => mp3, :title => tags["title"], :artist => tags["artist"], :album => tags["album"], :genre => tags["genre"], :duration => tags["duration"]) unless Song.first(:title => tags["title"], :duration => tags["duration"])
  end
  
  def self.import_from_folder(folder=APP_CONFIG[:import_folder_path])
    file_paths = Dir[folder+"/*.mp3"]
    songs, songs_imported = [], 0
    Song.all.each { |song| songs << song.mp3_name }
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
    
  def duration_converted
    minutes = (duration/60).to_i
    seconds = (((duration/60 - minutes)/100)*60*100).round
    return "#{minutes}:#{seconds}"
  end
  
end