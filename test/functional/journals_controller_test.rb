require File.dirname(__FILE__) + '/../test_helper'

class JournalsControllerTest < ActionController::TestCase

  def setup
    @journal = Factory(:journal)
  end

  should_be_restful do |resource|
    resource.formats = [:html, :xml]
    resource.destroy.flash = nil
  end
end
