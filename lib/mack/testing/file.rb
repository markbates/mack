require 'base64'
module Mack
  module Testing
    class FileWrapper # :nodoc:
      
      attr_reader :path
      attr_reader :file_name
      attr_reader :content
      attr_reader :size
      attr_reader :mime
      
      def initialize(path)
        @path = path
        @file_name = File.basename(path)
        extension = File.extname(path)
        extension = extension.gsub!(".", "")
        if extension and !extension.empty?
          @mime     = Mack::Utils::MimeTypes.instance.get(extension) if extension
        else
          @mime     = "application/octet-stream"
        end
        raw_content = File.read(path)
        @content = Base64.encode64(raw_content).strip
        @size    = @content.size
      end
    end
  end
end
