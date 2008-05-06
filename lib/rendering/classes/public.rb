module Mack
  module Rendering
    # Used when someone calls render(:public => "index")
    # This renders a file from the public directory.
    class Public < Base
      
      def render
        render_file(options[:public], {:dir => Mack::Configuration.public_directory, :ext => ".html", :layout => false}.merge(options))
      end
      
    end
  end
end