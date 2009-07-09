class SongsController < ApplicationController
  layout 'playlists'
  
  def index
    @songs = Song.without_deleted(:order => "name ASC")
  end
  
  def import_from_dropbox
    @songs_imported = Song.import_from_dropbox
    
    render :json => @songs_imported
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
        @song.add_uuid
        if @song.save
          Journal.add_song(@song.relative_url, @song.uuid)
        end
        flash[:notice] = 'Song was successfully created.'
        format.html { redirect_to "/songs/new" }
        format.xml  { render :xml => @song, :status => :created, :location => @song }
      else
        format.html { redirect_to "/songs/new" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @song = Song.find(params[:id])
    Journal.remove_song(@song.uuid)

    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :nothing => true, :response => 200 }
      format.xml  { head :ok }
    end
  end
end
