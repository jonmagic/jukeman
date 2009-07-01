class Item < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :song
  
  before_create :apply_ordinal
  
  def apply_ordinal
    if previous_item = Item.find(:last, :conditions => {:playlist_id => self.playlist_id})
      self.ordinal = previous_item.ordinal + 1
    else
      self.ordinal = 1
    end
  end
  
  def self.order(ids)
    counter = 1
    ids.each do |id|
      item = Item.find(id)
      item.ordinal = counter
      item.save
      counter += 1
    end
  end
  
end
