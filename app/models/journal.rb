class Journal < ActiveRecord::Base
  class << self
    def record(command)
      Journal.create(:command => command)
    end

    def add_song(url, uuid)
      Journal.record("Song.download(\"#{url}\", \"#{uuid}\")")
    end

    def new_playlist(name)
      if Playlist.create(:name => name)
        Journal.record("Playlist.create(\"#{name}\")")
      else
        nil
      end
    end

    def rename_playlist(old_name, new_name)
      if Playlist.rename(old_name, new_name)
        Journal.record("Playlist.rename(\"#{old_name}\", \"#{new_name}\")")
      else
        nil
      end
    end

    def remove_playlist(name)
      if Playlist.remove(name)
        Journal.record("Playlist.remove(\"#{name}\")")
      else
        nil
      end
    end
  end

  

  def apply
    eval(command)
  end
end
