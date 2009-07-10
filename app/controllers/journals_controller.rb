require 'date'
class JournalsController < ApplicationController
  # Journals API: Simply ask for all journals since a certain date/time.
  def index
    @journals = if params[:since]
      Journal.find(:all, :conditions => ["created_at > ?", Time.parse(params[:since]).strftime("%Y-%m-%d %H:%M:%S")])
    else
      Journal.find(:all)
    end

    respond_to do |format|
      format.xml  { render :xml => @journals }
      format.json { render :json => @journals }
    end
  end
  
  def clone
    @journals = []
    Location.all.each do |location|
      @journals << Journal.new(:command => "Location.create(:name => #{location.name.inspect}, :active_playlist => #{location.active_playlist.inspect})")
    end
    Playlist.all.each do |playlist|
      @journals << Journal.new(:command => "Playlist.create(:name => #{playlist.name.inspect})")
    end
    Song.without_deleted.each do |song|
      @journals << Journal.new(:command => "Song.download(#{song.relative_url.inspect}, #{song.uuid.inspect})")
    end
    Item.all(:order => "ordinal ASC").each do |item|
      @journals << Journal.new(:command => "Playlist.add_song(#{playlist_name.inspect}, #{song_uuid.inspect})")
    end
    
    respond_to do |format|
      format.xml  { render :xml => @journals }
      format.json { render :json => @journals }
    end
  end
end
