module Mack
  module Routes
    
    private
    class RouteObject # :nodoc:
      attr_accessor :options
      attr_accessor :path
      attr_accessor :wildcard
      attr_accessor :embedded_parameters
      attr_accessor :regex_patterns
      
      def initialize(path, options = {})
        self.path = path
        self.options = {:action => :index}.merge(options)
        # self.embedded_parameters = []
        # self.host_embedded_parameters = []
        self.regex_patterns = {}
        self.embedded_parameters = {:uri => [], :host => []}
        build_regex_patterns
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
      
      def options_with_parameters(url)
        format = (File.extname(url).blank? ? '.html' : File.extname(url))
        format = format[1..format.length]
        opts = self.options.merge(:format => format)
        url = url.gsub(/\.#{format}$/, '')
        if self.embedded_parameters[:uri].any?
          url.split('/').each_with_index do |seg, i|
            ep = self.embedded_parameters[:uri][i]
            unless ep.nil?
              opts[ep.to_sym] = seg
            end
          end
        end
        if self.wildcard
          caps = url.match(self.regex_patterns[:uri]).captures
          if caps
            opts[self.wildcard.to_sym] = caps.first.split('/')
          end
        end

        opts
      end
      
      private
      
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
      
      
      # def build_regex_pattern
      #   if self.options[:host]
      #     if self.options[:host].is_a?(Regexp)
      #       self.host_regex_pattern = self.options[:host]
      #     else
      #       reg = []
      #       self.options[:host].split('.').each_with_index do |seg, i|
      #         if seg.match(/^:/)
      #           self.host_embedded_parameters[i] = seg.gsub(':', '')
      #           reg << '[^/]+'
      #         else
      #           reg << seg.downcase
      #         end
      #       end
      #       self.host_regex_pattern = /^#{reg.join('.') + '(\..+$|$)'}/
      #       puts "self.host_regex_pattern: #{self.host_regex_pattern.inspect}"
      #     end
      #   end
      #   if self.path.is_a?(Regexp)
      #     self.regex_pattern = self.path
      #   elsif self.path.is_a?(String)
      #     reg = []
      #     if self.path == '/'
      #       self.regex_pattern = /^\/$/
      #     else
      #       self.path.split('/').each_with_index do |seg, i|
      #         if seg.match(/^:/)
      #           self.embedded_parameters[i] = seg.gsub(':', '')
      #           reg << '[^/]+'
      #         elsif seg.match(/^\*/)
      #           self.wildcard = seg.gsub('*', '')
      #           reg << '(.+)'
      #         else
      #           reg << seg.downcase
      #         end
      #       end
      #       self.regex_pattern = /^#{reg.join('/') + '(\..+$|$)'}/
      #     end
      #   else
      #     raise ArgumentError.new("'#{self.path}' is a #{self.path.class} and it should be either a String or Regexp!")
      #   end
      # end
      
    end # RouteObject
    
  end # Routes
end # Mack
