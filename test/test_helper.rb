ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'librmpd'
require 'mpdserver'

class ActiveSupport::TestCase
  def setup
    # clear database
    MongoMapper.database.collections.map(&:remove)
  end
  
  def teardown
  end
end
