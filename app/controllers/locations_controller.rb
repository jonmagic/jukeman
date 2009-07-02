class LocationsController < ApplicationController
  before_filter :load_locations, :except => [:create, :update, :destroy]
  
  def index

  end

  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @location }
    end
  end

  def new
    @location = Location.new
    @playlists = Playlist.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @location }
    end
  end

  def edit
    @playlists = Playlist.find(:all)
    @location = Location.find(params[:id])
  end

  def create
    if Journal.new_location(params[:location][:name], params[:location][:active_playlist])
      flash[:notice] = "Successfully created location."
      @location = Location.find_by_name(params[:location][:name])
      redirect_to url_for(@location)
    else
      flash[:warning] = "Failed to create playlist."
      redirect_to :back
    end
  end

  def update
    @location = Location.find(params[:id])

    if Journal.edit_location(@location.name, params[:location][:name], params[:location][:active_playlist])
      flash[:notice] = "Successfully updated location."
      redirect_to url_for(@playlist)
    else
      flash[:warning] = "Failed to update location."
      redirect_to :back
    end
  end

  def destroy
    @location = Location.find(params[:id])
    Journal.remove_location(@location.name)

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def load_locations
      @locations = Location.find(:all)
    end
end
