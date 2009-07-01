require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  should_have_db_column :playlist_id
  should_have_db_column :song_id
  should_have_db_column :ordinal
end
