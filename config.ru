# RAILS_ROOT/config.ru
require "config/environment"

# middleware
use Rails::Rack::LogTailer
use Rails::Rack::Static
require 'rack/gridfs' # configure the rack-gridfs adapter
use Rack::GridFS, :hostname => 'localhost', :port => 27017, :database => "jukeman-#{RAILS_ENV}", :prefix => "gridfs", :slave_ok => true

# setup the dispatcher
run ActionController::Dispatcher.new