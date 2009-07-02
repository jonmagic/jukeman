class Location < ActiveRecord::Base
  validates_presence_of :name, :active_playlist
  validates_uniqueness_of :name
  
  class << self
    def edit_location(previous_name, new_name, active_playlist)
      location = Location.find_by_name(previous_name)
      location.update_attributes(:name => new_name, :active_playlist => active_playlist)
    end
    
    def remove(name)
      Location.find_by_name(name).destroy
    end
    
  end

end
