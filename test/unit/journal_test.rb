require File.dirname(__FILE__) + '/../test_helper'

class JournalTest < ActiveSupport::TestCase
  should_have_db_column :command
end
