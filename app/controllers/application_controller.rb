# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  # def http_basic_authenticate
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == APP_CONFIG[:username] && password == APP_CONFIG[:password]
  #   end
  # end
  
  before_filter :load_playlists
  def load_playlists
    @playlists = Playlist.all
  end
  
  def load_totals(songs)
    totals = {}
    totals["quantity"] = 0
    totals["minutes"] = 0
    totals["seconds"] = 0
    duration = 0
    songs.each do |song|
      totals["quantity"] += 1
      if song.duration
        duration += song.duration
      end
    end
    minutes = (duration/60).to_i
    seconds = (((duration/60 - minutes)/100)*60*100).round
    totals["duration"] = minutes.to_s+" minutes, "+('%.02d' % seconds)+" seconds."
    return totals
  end
end
