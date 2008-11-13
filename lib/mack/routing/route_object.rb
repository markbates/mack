module Mack
  module Routes
    
    private
    class RouteObject # :nodoc:
      attr_accessor :options
      attr_accessor :path
      attr_accessor :wildcard
      attr_accessor :embedded_parameters
      attr_accessor :regex_patterns
      attr_accessor :insertion_order
      attr_accessor :deferred
      
      def initialize(path, options = {})
        self.path = path
        self.options = {:action => :index}.merge(options)
        self.deferred = self.options.delete(:deferred?) || false
        # self.embedded_parameters = []
        # self.host_embedded_parameters = []
        self.regex_patterns = {}
        self.embedded_parameters = {:uri => [], :host => []}
        build_regex_patterns
        
        self.insertion_order = Mack::Routes::RouteObject.next_insertion_index
      end
      
      def ==(other)
        self.options == other
      end
      
      def match?(url)
        if url.downcase.match(self.regex_patterns[:uri])
          if self.options[:format]
            format = (File.extname(url).blank? ? '.html' : File.extname(url))
            format = format[1..format.length]
            return format.to_sym == self.options[:format]
          end
          return true
        end
        return false
      end
      
      def options_with_parameters(url, host = nil)
        format = (File.extname(url).blank? ? '.html' : File.extname(url))
        format = format[1..format.length]
        opts = self.options.merge(:format => format)
        url = url.gsub(/\.#{format}$/, '')
        opts.merge!(get_embedded_parameters(:uri, url, '/'))
        unless host.nil?
          opts.merge!(get_embedded_parameters(:host, host, '.'))
          opts.merge!(:host => host) if self.options[:host]
        end
        if self.wildcard
          caps = url.match(self.regex_patterns[:uri]).captures
          if caps
            opts[self.wildcard.to_sym] = caps.first.split('/')
          end
        end

        opts
      end
      
      def <=>(other)
        self.insertion_order <=> other.insertion_order
      end
      
      private
      
      def self.next_insertion_index
        (@__next_insertion_index ||= 0)
        @__next_insertion_index += 1
      end
      
      def get_embedded_parameters(name, path, splitter = '/')
        vals = {}
        if self.embedded_parameters[name].any? && !path.nil?
          path.split(splitter).each_with_index do |seg, i|
            ep = self.embedded_parameters[name][i]
            unless ep.nil?
              vals[ep.to_sym] = seg
            end
          end
        end
        vals
      end
      
      def build_regex_patterns
        {:uri => {:path => self.path, :splitter => '/', :emb_pat => ':'}, :host => {:path => self.options[:host], :splitter => '.', :emb_pat => ':'}}.each do |k, v|
          build_regex_pattern(k, v[:path], v[:splitter], v[:emb_pat])
        end
      end
      
      def build_regex_pattern(name, path, splitter = '/', emb_pat = ':')
        return if path.nil?
        if path.is_a?(Regexp)
          self.regex_patterns[name] = self.path
        elsif self.path.is_a?(String)
          reg = []
          if path == '/'
            self.regex_patterns[name] = /^\/$/
          else
            path.split(splitter).each_with_index do |seg, i|
              if seg.match(/^#{emb_pat}/)
                self.embedded_parameters[name][i] = seg.gsub(emb_pat, '')
                reg << '[^/]+'
              elsif seg.match(/^\*/)
                self.wildcard = seg.gsub('*', '')
                reg << '(.+)'
              else
                reg << seg.downcase
              end
            end
            self.regex_patterns[name] = /^#{reg.join(splitter) + '(\..+$|$)'}/
          end
        else
          raise ArgumentError.new("'#{path}' is a #{path.class} and it should be either a String or Regexp!")
        end
      end
      
    end # RouteObject
    
  end # Routes
end # Mack
