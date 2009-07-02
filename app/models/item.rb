class Item < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :song
  
  before_create :apply_ordinal
  
  def apply_ordinal
    if previous_item = Item.find(:last, :conditions => {:playlist_id => self.playlist_id}, :order => 'ordinal ASC')
      self.ordinal = previous_item.ordinal + 1
    else
      self.ordinal = 1
    end
  end
  
  class << self
    
    def remove(playlist_name, item_ordinal)
      playlist = Playlist.find_by_name(playlist_name)
      Item.find(:first, :conditions => {:playlist_id => playlist.id, :ordinal => item_ordinal}).destroy
    end
    
    
    def ordinal_shift(playlist_name, ordinals)
      playlist = Playlist.find_by_name(playlist_name)
      counter = 0
      move_to = {}
      ordinals.each do |ordinal|
        counter += 1
        if ordinal != counter
          move_to[ordinal] = counter
        end
      end
      Item.find(:all, :conditions => {:playlist_id => playlist.id}, :order => 'ordinal ASC').each do |item|
        item.update_attributes(:ordinal => move_to[item.ordinal]) if move_to.has_key?(item.ordinal)
      end
    end

  end
end
