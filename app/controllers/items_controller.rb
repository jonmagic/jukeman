class ItemsController < ApplicationController
  layout false
  before_filter :http_basic_authenticate

  def create
    @playlist = Playlist.find(params[:item][:playlist_id])
    @song = Song.find(params[:item][:song_id])
    
    if Journal.add_playlist_item(@playlist.name, @song.uuid)
      render :nothing => true, :response => 200
    else
      render :nothing => true, :response => 500
    end
  end
  
  def sort
    ordinals = params[:item]
    playlist = Playlist.find(params[:playlist_id])
    Journal.reorder_playlist(playlist.name, ordinals)
    render :text => 'Yay'
  end
  
  def update
    
  end
  
  def destroy
    @item = Item.find(params[:id])
    Journal.remove_playlist_item_by_ordinal(@item.playlist.name, @item.ordinal)
    
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :nothing => true, :response => 200 }
      format.xml  { head :ok }
    end
  end

end
