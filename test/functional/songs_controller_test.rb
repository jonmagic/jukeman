require File.dirname(__FILE__) + '/../test_helper'

class SongsControllerTest < ActionController::TestCase

  def setup
    @song = Factory(:song)
  end

  should_be_restful do |resource|
    resource.formats = [:html, :xml]
    resource.destroy.flash = nil
  end
end
