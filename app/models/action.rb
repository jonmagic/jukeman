class Action
  # include MongoMapper::EmbeddedDocument
  # 
  # key :object,        String
  # key :method_name,   Symbol
  # key :arguments,     Array
  # key :completed,     Time
  # 
  # alias_method :args, :arguments
  # 
  # def run
  #   begin
  #     if args.empty?
  #       result = object.constantize.send(method_name)
  #     else
  #       result = object.constantize.send(method_name, *args)
  #     end
  #     self.destroy
  #     result
  #   rescue Exception => exception
  #     Rails.logger.info exception.message
  #   end
  # end
  # 
  # ##
  # # Fetch actions and run them.
  # 
  # def self.fetch_and_run_actions
  #   location = Location.find_by_name(APP_CONFIG[:location])
  #   location.actions.each do |action|
  #     if action.completed.blank?
  #       result = action.run
  #       Rails.logger.info(
  #         "* #{action.object.to_s}.#{action.method_name}" <<
  #         "(#{action.args.join(', ')}) => #{(action.errors || result).to_s}"
  #       )
  #       action.completed = Time.now
  #     end
  #   end
  #   location.save
  # end
  # 
  # def destroy
  #   location = Location.find_by_name(APP_CONFIG[:location])
  #   location.actions.delete(self)
  #   location.save
  # end
  # 
  # def self.test_method
  #   Rails.logger.info "test method output"
  #   true
  # end
  # 
end

# l = Location.first
# l.actions << Action.new(:object => "Player", :method_name => :clear)
# l.save
# 
# l.actions << Action.new(:object => "Location", :method_name => :load_playlist)
# l.save
# 
# l.actions << Action.new(:object => "Player", :method_name => :play)
# l.save