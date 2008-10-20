module Mack
  module Routes
    
    private
    class ResourceProxy # :nodoc:
      
      attr_accessor :controller
      attr_accessor :routes
      attr_accessor :resources
      
      def initialize(controller, resources = [])
        self.controller = controller
        self.routes = []
        self.resources = resources
      end
      
      def method_missing(sym, *args)
        connect(sym, *args)
      end
      
      def resource(name, options = {}, &block)
        if block_given?
          proxy = Mack::Routes::ResourceProxy.new(name, [self.resources, name].flatten)
          yield proxy
          proxy.routes.each do |route|
            Mack::Routes::RouteMap.instance.connect_with_name("#{name}_#{route[:name]}", route[:path], options.merge(route[:options]))
          end
        end
        x = []
        self.resources.each do |r|
          x << r
          x << ":#{r.to_s.singular}_id"
        end
        x << name
        x = x.join('/')
        Mack::Routes::RouteMap.instance.build_resource_routes(name, x, name, options)
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
