require 'httparty'

class PlayerController < ApplicationController
  include HTTParty

  def index
    if params[:location_id] && params[:location_id] != Location.first(:name => APP_CONFIG[:location]).id.to_s
      hash = Location.find(params[:location_id]).get_status
    else
      active_playlist = Playlist.find(Location.first(:name => APP_CONFIG[:location]).playlist_id)
      hash = {}
      hash["state"]             = Player.state
      hash["current_song"]      = Player.current_song unless Player.current_song.blank?
      hash["active_playlist"]   = {:id => active_playlist.id, :name => active_playlist.name} unless active_playlist.blank?
      hash["playlists"]         = Playlist.all(:destroyed_at => nil).collect { |p| {:id => p.id, :name => p.name} }
    end
    render_json hash.to_json
  end

  def create
    if params[:location_id] && params[:location_id] != Location.first(:name => APP_CONFIG[:location]).id.to_s
      parameters = ""
      parameters += "activate_playlist=#{params[:activate_playlist]}" unless params[:activate_playlist].blank?
      parameters += "player_action=#{params[:player_action]}" unless params[:player_action].blank?
      self.class.post("http://#{Location.find(params[:location_id]).ip}:3333/player?"+parameters)
      # Location.find(params[:location_id]).update_player(hash)
    else
      @location = Location.first(:name => APP_CONFIG[:location])
      @location.activate_playlist(params[:activate_playlist]) unless params[:activate_playlist].blank?
      Player.send(params[:player_action].to_sym) unless params[:player_action].blank?
    end
    render :nothing => true, :response => 200
  end

end

# http://0.0.0.0:3000/locations/4b88157be5947c0662000003/player?activate_playlist=4b8592b9e5947c9d8200000e