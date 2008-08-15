require 'base64'
module Mack
  module Testing
    class FileWrapper
      
      attr_reader :path
      attr_reader :file_name
      attr_reader :content
      attr_reader :size
      
      def initialize(path)
        @path = path
        @file_name = File.basename(path)
        raw_content = File.read(path)
        @content = Base64.encode64(raw_content)
        @size    = @content.size
      end
    end
  end
end
