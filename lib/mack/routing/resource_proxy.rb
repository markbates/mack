module Mack
  module Routes
    
    private
    class ResourceProxy # :nodoc:
      
      attr_accessor :controller
      attr_accessor :routes
      
      def initialize(controller)
        self.controller = controller
        self.routes = []
      end
      
      def method_missing(sym, *args)
        connect(sym, *args)
      end
      
      private
      def connect(name, path, options = {})
        route = {}
        route[:name] = name.to_s.gsub(/^#{self.controller}/, '')
        route[:options] = {:controller => self.controller, :action => route[:name].to_sym, :method => :get}.merge(options)
        paths = path.split('/')
        paths.insert(0, self.controller.to_s)
        route[:path] = paths.reject{|m| m.blank?}.uniq.join('/')
        routes << route
      end
      
    end # ResourceProxy
    
  end # Routes
end # Mack
