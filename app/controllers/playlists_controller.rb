class PlaylistsController < ApplicationController

  def show
    @playlist = Playlist.find(params[:id])
    @items = []
    @items = @playlist.songs.collect { |song| Song.find(song) }
    @totals = load_totals(@items)
    respond_to do |format|
      format.html
      format.yaml { render :yaml => @items }
    end
  end

  def new
    @playlist = Playlist.new
    render :layout => false
  end
  
  def create
    @playlist = Playlist.new(params[:playlist])
    if @playlist.save
      flash[:notice] = "Successfully created playlist."
      redirect_to root_url
    else
      flash[:warning] = "Failed to create playlist."
      redirect_to :back
    end  
  end
  
  def edit
    @playlist = Playlist.find(params[:id])
    render :layout => false
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update_attributes(params[:playlist])
      flash[:notice] = "Successfully updated playlist."
      respond_to do |format|
        format.html { redirect_to playlist_url(@playlist) }
        format.json { render :nothing => true, :response => 200 }
      end
    else
      flash[:warning] = "Failed to update playlist."
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render :nothing => true, :response => 500 }
      end
    end
  end
  
  def add # add song to playlist
    @playlist = Playlist.find(params[:playlist_id])
    if @song = Song.find(params[:song_id])
      @playlist.songs << @song.id
      @playlist.save
      render :nothing => true, :response => 200
    else
      render :nothing => true, :response => 500
    end
  end
  
  def destroy
    @playlist = Playlist.find(params[:id])
    if @playlist.destroy
      flash[:notice] = "Successfully removed the playlist."
      redirect_to root_url
    else
      flash[:warning] = "Failed to remove playlist."
      redirect_to :back
    end
  end
end