module Mack
  module Rendering
    # Used when someone calls render(:partial => "latest_news")
    class Partial < Base
      
      def render
        render_file(options[:partial], {:is_partial => true}.merge(options))
      end
      
    end
  end
end