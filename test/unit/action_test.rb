# require File.dirname(__FILE__) + '/../test_helper'
# 
# class ActionTest < ActiveSupport::TestCase
#   def setup
#     MongoMapper.database.collections.map(&:remove)
#     Song.import_from_folder("#{RAILS_ROOT}/music")
#     @playlist = Playlist.create(:name => 'Sample Playlist', :songs => Song.all.collect {|s| s.id})
#     Location.create(:name => APP_CONFIG[:location], :playlist_id => Playlist.first.id)
#     @location = Location.first(:name => APP_CONFIG[:location])
#   end
#     
#   context "actions" do
# 
#     should "save if valid" do
#       @actions = @location.actions << Action.new(:object => 'Player', :method_name => :play)
#       assert @location.save
#       assert_equal 1, Location.first.actions.length
#     end
#     
#   end
#   
#   context "running an action" do
#     setup do
#       @location.actions << Action.new(:object => 'Action', :method_name => :test_method)
#       @location.save
#       @action = Location.first(:name => APP_CONFIG[:location]).actions.first
#     end
# 
#     should "run the action" do
#       assert @action.run
#       assert_equal 0, Location.first(:name => APP_CONFIG[:location]).actions.length
#     end
#   end
#   
#   context "finding and running actions" do
#     setup do
#       @location.actions << Action.new(:object => 'Action', :method_name => :test_method)
#       @location.actions << Action.new(:object => 'Action', :method_name => :test_method)
#       @location.save
#       @action = Location.first(:name => APP_CONFIG[:location]).actions.first
#     end
# 
#     should "fetch and run all actions" do
#       assert_equal 2, Location.first(:name => APP_CONFIG[:location]).actions.length
#       assert Action.fetch_and_run_actions
#       assert_equal 0, Location.first(:name => APP_CONFIG[:location]).actions.length
#     end
#   end
#   
#   
# end