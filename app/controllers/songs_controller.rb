class SongsController < ApplicationController
  
  def index
    @songs = Song.all(:destroyed_at => nil)
    @totals = load_totals(@songs)
  end
  
  def new
    @song = Song.new
    render :layout => false
  end

  def create
    if Song.save(params[:song])
      flash[:notice] = "Successfully uploaded song."
      redirect_to root_url
    else
      flash[:notice] = "Failed to upload song."
      redirect_to root_url
    end
  end
  
  def import
    Navvy::Job.enqueue(Song, :import_from_folder)
    render :nothing => true, :response => 200
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    respond_to do |format|
      format.json { render :nothing => true, :response => 200 }
    end
  end
end
