require File.dirname(__FILE__) + '/../test_helper'
require 'librmpd'
require 'mpdserver'

class PlayerTest < ActiveSupport::TestCase
  def setup
    # setup test mpd server
    @server = MPDTestServer.new APP_CONFIG[:mpd_port]
    @server.start
    @server.audit = true
  end
  
  def teardown
    sleep 1
    @server.stop
  end
  
  context "when controlling mpd it" do
    should "play" do
      assert Player.play
    end
    should "next_song" do
      assert Player.next_song
    end
    should "previous_song" do
      assert Player.previous_song
    end
    should "stop" do
      assert Player.stop
    end
    should "clear" do
      assert Player.clear
    end
  end
  
end