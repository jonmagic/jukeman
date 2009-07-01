require File.dirname(__FILE__) + '/../test_helper'

class SongTest < ActiveSupport::TestCase
  should_have_db_column :name
  should_have_db_column :duration
  should_have_db_column :artist
  should_have_db_column :album
  should_have_db_column :genre
end
