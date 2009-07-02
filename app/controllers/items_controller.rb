class ItemsController < ApplicationController
  layout false

  def create
    @playlist = Playlist.find(params[:item][:playlist_id])
    @song = Song.find(params[:item][:song_id])
    
    if Journal.add_song_to_playlist_and_reorder(@playlist.name, @song.uuid)
      render :nothing => true, :response => 200
    else
      render :nothing => true, :response => 500
    end
  end
  
  def sort
    ordinals = params[:item]
    Item.ordinal_shift(params[:playlist_id], ordinals)
    render :text => 'Yay'
  end
  
  def update
    
  end
  
  def destroy
    @item = Item.find(params[:id])
    Journal.remove_item_and_reorder_playlist(@item.playlist.name, @item.ordinal)
    
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :nothing => true, :response => 200 }
      format.xml  { head :ok }
    end
  end

end
