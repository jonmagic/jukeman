# encoding: utf-8

class Mp3Uploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader
  storage :file

  # Override the directory where uploaded files will be stored
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "songs"
  end

  # Override the filename of the uploaded files
  def filename
    Rails.logger.info self.inspect
    "#{model['_id']}.mp3" if original_filename
  end

end
