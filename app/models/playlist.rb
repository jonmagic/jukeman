class Playlist < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :items, :dependent => :destroy
  has_many :songs, :through => :items

  class << self
    def rename(old_name, new_name)
      Playlist.find_by_name(old_name).update_attributes(:name => new_name)
    end

    def remove(name)
      Playlist.find_by_name(name).destroy!
    end
  end

end
