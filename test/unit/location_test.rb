require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < ActiveSupport::TestCase
  should_have_db_column :name
  should_have_db_column :polled_at
  should_have_db_column :active_playlist
end
