class Playlist
  include MongoMapper::Document
  key :name, String, :require => true, :unique => true
  key :songs, Array  
end
