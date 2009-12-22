include Mongo
include GridFS
module Grip
  
  module InstanceMethods
    
    # Save Path: <classname>/<id>/<method_name>/<file_basename>
    def file_save_path name,file_name
      [self.class.to_s.underscore,self.id,name,file_name].join("/")
    end
    
    def save_attachments
      self.class.attachment_definitions.each do |attachment|
        name, file = attachment
        if (file.is_a?(File) || file.is_a?(Tempfile))
          file_path = file.original_filename rescue file.path.split("/").last
          
          path = file_save_path(name,file_path)
          GridStore.open(self.class.database, path, 'w') do |f|
            
            content_type = file.content_type rescue MIME::Types.type_for(file.path).first.content_type
            
            f.content_type = content_type
            f.puts file.read
          end
          
          self.send("#{name}_path=",path)
          save_to_collection
        end
      end
    end
    
    def destroy_attached_files
      self.class.attachment_definitions.each do |name, attachment|
        GridStore.unlink(self.class.database, send("#{name}_path"))
      end
    end
    
    def file_from_grid name
      GridStore.open(self.class.database, send("#{name}_path"), 'r') {|f| f }
    end

  end
  module ClassMethods
    
    def has_grid_attachment name
      include InstanceMethods
      
      # thanks to thoughtbot's paperclip!
      write_inheritable_attribute(:attachment_definitions, {}) if attachment_definitions.nil?
      attachment_definitions[name] = {}
      
      after_save :save_attachments
      before_destroy :destroy_attached_files
      
      define_method name do
        file_from_grid name
      end

      define_method "#{name}=" do |file|
        self.class.attachment_definitions[name] = file
      end
      
      key "#{name}_path".to_sym, String
    end
    
    def attachment_definitions
      read_inheritable_attribute(:attachment_definitions)
    end

  end
  
  def self.included(base)
    base.extend Grip::ClassMethods
  end
end
