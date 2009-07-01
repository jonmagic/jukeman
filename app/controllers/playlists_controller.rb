class PlaylistsController < ApplicationController
  layout 'playlists'

  def show
    @songs = Item.scoped_by_playlist_id(params[:id])
  end
  
  def new
    @playlist = Playlist.new
  end
  
  def create
    @playlist = Playlist.new(params[:playlist])
    if @playlist.save
      flash[:notice] = "Successfully created playlist."
      redirect_to "/playlists/#{@playlist.id}/songs"
    else
      flash[:warning] = "Failed to create playlist."
      redirect_to :back
    end
  end
  
  def edit
    @playlist = Playlist.find(params[:id])
  end
  
  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update_attributes(params[:playlist])
      flash[:notice] = "Successfully updated playlist."
      redirect_to url_for(@playlist)
    else
      flash[:warning] = "Failed to update playlist."
      redirect_to :back
    end
  end
  
  def destroy
    @playlist = Playlist.find(params[:id])
    @playlist.destroy
  end
  
end
