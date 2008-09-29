module Mack
  module Routes
    
    private
    class RouteObject # :nodoc:
      attr_accessor :options
      attr_accessor :path
      attr_accessor :regex_pattern
      attr_accessor :embedded_parameters
      attr_accessor :wildcard
      
      def initialize(path, options = {})
        self.path = path
        self.options = {:action => :index}.merge(options)
        self.embedded_parameters = []
        build_regex_pattern
      end
      
      def ==(other)
        self.options == other
      end
      
      def match?(url)
        if url.downcase.match(self.regex_pattern)
          if self.options[:format]
            format = (File.extname(url).blank? ? '.html' : File.extname(url))
            format = format[1..format.length]
            return format.to_sym == self.options[:format]
          end
          return true
        end
        return false
      end
      
      def options_with_parameters(url)
        format = (File.extname(url).blank? ? '.html' : File.extname(url))
        format = format[1..format.length]
        opts = self.options.merge(:format => format)
        url = url.gsub(/\.#{format}$/, '')
        if self.embedded_parameters.any?
          url.split('/').each_with_index do |seg, i|
            ep = self.embedded_parameters[i]
            unless ep.nil?
              opts[ep.to_sym] = seg
            end
          end
        end
        if self.wildcard
          caps = url.match(self.regex_pattern).captures
          if caps
            opts[self.wildcard.to_sym] = caps.first.split('/')
          end
        end

        opts
      end
      
      private
      def build_regex_pattern
        if self.path.is_a?(Regexp)
          self.regex_pattern = self.path
        elsif self.path.is_a?(String)
          reg = []
          if self.path == '/'
            self.regex_pattern = /^\/$/
          else
            self.path.split('/').each_with_index do |seg, i|
              if seg.match(/^:/)
                self.embedded_parameters[i] = seg.gsub(':', '')
                reg << '[^/]+'
              elsif seg.match(/^\*/)
                self.wildcard = seg.gsub('*', '')
                reg << '(.+)'
              else
                reg << seg.downcase
              end
            end
            self.regex_pattern = /^#{reg.join('/') + '(\..+$|$)'}/
          end
        else
          raise ArgumentError.new("'#{self.path}' is a #{self.path.class} and it should be either a String or Regexp!")
        end
      end
      
    end # RouteObject
    
  end # Routes
end # Mack
