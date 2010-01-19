ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'librmpd'
require 'mpdserver'

class ActiveSupport::TestCase
  def setup
    # clear database
    MongoMapper.database.collections.map(&:remove)
    # setup test mpd server
    @server = MPDTestServer.new APP_CONFIG[:mpd_port]
    @server.start
    @server.audit = true
  end
  
  def teardown
    @server.stop
  end
end
