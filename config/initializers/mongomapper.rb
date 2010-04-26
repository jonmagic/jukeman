# mongomapper connection
require 'mongo/gridfs'
MongoMapper.connection = Mongo::Connection.new('10.111.222.9', 27017, :slave_ok => true) # :logger => Rails.logger,
MongoMapper.database = "jukeman-#{RAILS_ENV}"
Dir[Rails.root + 'app/models/**/*.rb'].each do |model_path|
  File.basename(model_path, '.rb').classify.constantize
end