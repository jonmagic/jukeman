# mongomapper connection
require 'mongo/gridfs'
MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, :logger => Rails.logger, :slave_ok => true) # 
MongoMapper.database = "jukeman-#{RAILS_ENV}"
Dir[Rails.root + 'app/models/**/*.rb'].each do |model_path|
  File.basename(model_path, '.rb').classify.constantize
end
MongoMapper.ensure_indexes!