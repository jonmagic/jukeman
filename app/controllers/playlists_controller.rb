class PlaylistsController < ApplicationController

  def show
    @playlist = Playlist.find(params[:id])
    @items = []
    @items = @playlist.songs.collect { |song| Song.find(song) }
    respond_to do |format|
      format.html
      format.yaml { render :yaml => @items }
    end
  end

  def new
    @playlist = Playlist.new
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
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update_attributes(params[:playlist])
      flash[:notice] = "Successfully updated playlist."
      redirect_to playlist_url(@playlist)
    else
      flash[:warning] = "Failed to update playlist."
      redirect_to :back
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