class PlayerController < ApplicationController

  def index
    active_playlist = Playlist.find(Location.first(:name => APP_CONFIG[:location]).playlist_id)
    hash = {}
    hash["state"]             = Player.state
    hash["current_song"]      = Player.current_song unless Player.current_song.blank?
    hash["active_playlist"]  = {:id => active_playlist.id, :name => active_playlist.name} unless active_playlist.blank?
    hash["playlists"]         = Playlist.all(:destroyed_at => nil).collect { |p| {:id => p.id, :name => p.name} }
    render_json hash.to_json
  end

  def create
    @location = Location.first(:name => APP_CONFIG[:location])
    @location.activate_playlist(params[:activate_playlist]) unless params[:activate_playlist].blank?
    Player.send(params[:player_action].to_sym) unless params[:player_action].blank?
    render :nothing => true, :response => 200
  end

end