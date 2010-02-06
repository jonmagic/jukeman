class LocationsController < ApplicationController
  
  def index
    @locations = Location.all
  end
  
  def show
    @location = Location.find(params[:id])
  end
  
  def new
    @location = Location.new
  end
  
  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = "Location was created successfully"
      redirect_to locations_path
    else
      render :nothing => true, :response => 500
    end
  end
  
  def edit
    @location = Location.find(params[:id])
  end
  
  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = "Location was updated successfully"
      redirect_to locations_path
    else
      render :nothing => true, :response => 500
    end
  end
  
  def destroy
    @location = Location.find(params[:id])
    if @location.destroy
      render :nothing => true, :response => 200
    else
      render :nothing => true, :response => 500
    end
  end
  
end