class SongsController < ApplicationController
  
  def index
    @songs = Song.all(:destroyed_at => nil)
    @totals = load_totals(@songs)
  end

  def create
    @song = Song.new(params[:song])
    if @song.save
      flash[:notice] = "Successfully uploaded song."
      redirect_to root_url
    else
      flash[:notice] = "Failed to upload song."
      redirect_to root_url
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    respond_to do |format|
      format.json { render :nothing => true, :response => 200 }
    end
  end
end
