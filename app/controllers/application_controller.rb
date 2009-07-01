# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :load_playlists
  
  # comment this out and put it into the controllers you want protected
  # before_filter :http_basic_authenticate
    
  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == APP_CONFIG[:username] && password == APP_CONFIG[:password]
    end
  end
  
  def load_playlists
    @playlists = Playlist.find(:all)
  end
  
end