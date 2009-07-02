class PlaylistsController < ApplicationController
  layout 'playlists'

  def show
    @playlist = Playlist.find(params[:id])
    @items = Item.scoped_by_playlist_id(params[:id], :sort => 'ordinal ASC')
    @items = @items.sort_by{|item| [item.ordinal, item.id]}
  end
  
  def new
    @playlist = Playlist.new
  end
  
  def create
    if Journal.new_playlist(params[:playlist][:name])
      flash[:notice] = "Successfully created playlist."
      redirect_to '/'
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

    if Journal.rename_playlist(@playlist.name, params[:playlist][:name])
      flash[:notice] = "Successfully updated playlist."
      redirect_to url_for(@playlist)
    else
      flash[:warning] = "Failed to update playlist."
      redirect_to :back
    end
  end
  
  def destroy
    @playlist = Playlist.find(params[:id])
    Journal.remove_playlist(@playlist.name)
    
    respond_to do |format|
      format.html { redirect_to "/" }
      format.xml  { head :ok }
    end
  end
  
end