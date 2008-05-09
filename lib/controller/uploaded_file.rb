require File.join(File.dirname(__FILE__), 'request')
module Mack
  # Wraps the Hash that Rack creates when you post a file.
  class Request::UploadedFile
    
    # The name of the file uploaded
    attr_reader :file_name
    # The type of the file uploaded
    attr_reader :file_type
    # The name of the parameter used to upload the file
    attr_reader :param_name
    # A File object representing the uploaded file.
    attr_reader :temp_file
    attr_reader :head
    # The destination path you want the file to be saved to.
    attr_accessor :destination_path
    
    def initialize(param, destination_path = nil)
      @file_name = param[:filename]
      @file_type = param[:type]
      @param_name = param[:name]
      @temp_file = param[:tempfile]
      @head = param[:head]
      @destination_path = nil
    end
    
    # Set the destination_path you want the file to be saved to.
    # This can be a full path, or an array that will get joined with File.join.
    # 
    # Examples:
    #   @uploaded_file.destination_path = "/path/to/my/destination/foo.jpg"
    #   @uploaded_file.destination_path = ["path", "to", "my", "destination", "foo.jpg"]
    def destination_path=(path)
      if path.is_a?(Array)
        @destination_path = File.join(path)
      else
        @destination_path = path
      end
    end
    
    # Takes/sets the destination_path and then calls the save method.
    def save_to(*destination_path)
      self.destination_path = *destination_path
      save
    end
    
    # Saves the temp_file to the destination_path. This method will create the directory
    # tree of the destination_path if it does not exists.
    # Raises ArgumentError if the destination_path has not been set.
    def save
      raise ArgumentError.new("Destination path must be set!") if self.destination_path.blank?
      FileUtils.mkdir_p(File.dirname(self.destination_path))
      FileUtils.mv(self.temp_file.path, self.destination_path)
    end
    
  end
end # :nodoc: