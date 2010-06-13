# export all the songs to the filesystem
`mkdir #{RAILS_ROOT}/public/songs`
Song.all.each do |song|
  f = File.open("#{RAILS_ROOT}/public/songs/#{song.id}.mp3", "w")
  f << song.mp3.read
  f.close()
end

# export all the records so they can be reimported
include Mongo
db   = Connection.new.db('jukeman-development')
files = db.collection('fs.files')
files.drop
chunks = db.collection('fs.chunks')
chunks.drop