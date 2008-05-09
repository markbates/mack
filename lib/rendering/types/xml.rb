module Mack
  module Rendering
    # Used when someone calls render(:xml => "rss_feed")
    class Xml < Base
      
      def render
        begin
          # Try to render the action:
          return render_file(options[:xml], options.merge(:format => :xml, :ext => ".xml.erb"))
        rescue Errno::ENOENT => e
          begin
            # If the action doesn't exist on disk, try to render it from the public directory:
            t = render_file(options[:xml], {:dir => Mack::Configuration.public_directory, :ext => ".xml.erb", :layout => false}.merge(options.merge(:format => :xml)))
            return t
          rescue Errno::ENOENT => ex
          end
          # Raise the original exception because something bad has happened!
          raise e
        end
      end
      
    end
  end
end