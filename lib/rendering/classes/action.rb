module Mack
  module Rendering
    # Used when someone calls render(:action => "index")
    class Action < Base
      
      def render
        begin
          # Try to render the action:
          return render_file(options[:action], options)
        rescue Errno::ENOENT => e
          begin
            # If the action doesn't exist on disk, try to render it from the public directory:
            t = render_file(options[:action], {:dir => Mack::Configuration.public_directory, :ext => ".#{params(:format)}", :layout => false}.merge(options))
            # Because it's being served from public don't wrap a layout around it!
            # self.controller.instance_variable_get("@render_options").merge!({:layout => false})
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