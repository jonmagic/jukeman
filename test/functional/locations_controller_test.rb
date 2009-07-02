require File.dirname(__FILE__) + '/../test_helper'

class LocationsControllerTest < ActionController::TestCase

  def setup
    @location = Factory(:location)
  end

  should_be_restful do |resource|
    resource.formats = [:html, :xml]
    resource.destroy.flash = nil
  end
end
