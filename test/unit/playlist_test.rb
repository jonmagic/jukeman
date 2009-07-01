require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase

  should_require_attributes :name
  should_require_unique_attributes :name
  
end
