require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Used to render files stored in the public directory. These files are NOT run through any engines
      # and are returned 'as is'.
      class Public < Mack::Rendering::Type::Base
        
        # Attempts to find the file on disk and return it. If no file extension is provided then the 'format' 
        # of the request is appended to the file name.
        def render
          p_file = self.render_value
          if File.extname(p_file).blank?
            p_file = "#{p_file}.#{self.options[:format]}"
          end
          find_file(Mack::Paths.public(p_file)) do |f|
            return File.open(f).read
          end
          raise Mack::Errors::ResourceNotFound.new(p_file)
        end
        
        # No layouts should be used with this Mack::Rendering::Type
        def allow_layout?
          false
        end
        
      end # Public
    end # Type
  end # Rendering
end # Mack