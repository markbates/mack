module Mack
  module ViewHelpers # :nodoc:
    module StringHelpers
      
      # Takes a count integer and a word and returns a phrase containing the count
      # and the correct inflection of the word.
      # 
      # Examples:
      #   pluralize_word(0, "error") # => "0 errors"
      #   pluralize_word(1, "error") # => "1 error"
      #   pluralize_word(2, "error") # => "2 errors"
      def pluralize_word(count, word)
        if count.to_i == 1
          "#{count} #{word.singular}"
        else
          "#{count} #{word.plural}"
        end
      end
      
      # Applies a simple HTML formatting scheme to the text. It first wraps the
      # whole string in a p tag. Then it converts any double carriage returns to
      # new p tags, and any single break tags to br tags.
      # 
      # Examples:
      #   simple_format("hello\n\ngoodbye\nhello, goodbye") # => "<p>hello</p>\n\n<p>goodbye\n<br />\nhello, goodbye</p>"
      def simple_format(text, options = {})
        if options.empty?
          p = "<p>"
        else
          p = "<p #{options.join("%s=\"%s\"", " ")}>"
        end
        x = text.to_s.dup
        x.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
        x.gsub!(/\n\n+/, "</p>\n\n#{p}")  # 2+ newline  -> paragraph
        x.gsub!(/([^\n]\n)(?=[^\n])/, "\\1<br />\n") # 1 newline   -> br
        "#{p}#{x}</p>"
      end
      
      # By this will convert all '<' tags to &lt;. You can specify specific tags
      # with the :tags => [...] option.
      # 
      # Examples:
      #   sanitize_html("<script>foo;</script>hello <b>mark</b>") # => "&lt;script>foo;&lt;/script>hello &lt;b>mark&lt;/b>"
      #   sanitize_html("<script>foo;</script>hello <b>mark</b>", :tags => :script) # =>  "&lt;script>foo;&lt;/script>hello <b>mark</b>"
      #   sanitize_html("< script>foo;</ script>hello <b>mark</b>", :tags => :script) # => "&lt;script>foo;&lt;/script>hello <b>mark</b>"
      def sanitize_html(html, options = {})
        h = html.to_s.dup
        unless options[:tags]
          return h.gsub("<", "&lt;")
        else
          [options[:tags]].flatten.each do |tag|
            h.gsub!(/<\s*#{tag}/i, "&lt;#{tag}")
            h.gsub!(/<\/\s*#{tag}/i, "&lt;/#{tag}")
          end
          return h
        end
      end
      
      alias_method :s, :sanitize_html
      
    end # StringHelpers
  end # ViewHelpers
end # Mack