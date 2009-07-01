class SongsController < ApplicationController
  layout 'playlists'
  
  def index
    @songs = Song.find(:all)
  end
  
  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @song }
    end
  end

  def new
    @song = Song.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @song }
    end
  end

  def create
    @song = Song.new(params[:song])

    respond_to do |format|
      if @song.save
        @song.read_id3_tags
        @song.save
        flash[:notice] = 'Song was successfully created.'
        format.html { redirect_to "/" }
        format.xml  { render :xml => @song, :status => :created, :location => @song }
      else
        format.html { redirect_to "/" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to "/" }
      format.xml  { head :ok }
    end
  end
end
