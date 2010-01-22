class Location
  include MongoMapper::Document
  
  key :name, String, :unique => true, :required => true
  key :playlist_id, ObjectId
  
  has_one :playlist
  has_many :actions
  
end