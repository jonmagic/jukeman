# RAILS_ROOT/config.ru
require "config/environment"

# middleware
use Rails::Rack::LogTailer
use Rails::Rack::Static
gem 'jnunemaker-rack-gridfs', '0.3.0'
require 'rack/gridfs' # configure the rack-gridfs adapter
use Rack::GridFS, :hostname => '10.111.222.9', :port => 27017, :database => "jukeman-#{RAILS_ENV}", :prefix => "gridfs", :slave_ok => true

# setup the dispatcher
run ActionController::Dispatcher.new