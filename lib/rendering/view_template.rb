module Mack
  module Rendering
    class ViewTemplate
      
      attr_accessor :options
      attr_accessor :view_binder
      
      def initialize(options = {})
        self.view_binder = Mack::Rendering::ViewBinder.new
        self.options = {:engine => "erb"}.merge(options)
      end
      
      def add_options(opts)
        self.options.merge!(opts)
      end
      
      def method_missing(sym, *args)
        self.options[sym]
      end
      
      def compile
        engine = eval("Mack::Rendering::Engines::#{self.engine.camelcase}").render(self, binding)
        # engine.render(File.open(File.join(self.options[:file_path], "app", "views", self.options[:controller], self.options[:action] + ".#{self.format}.#{self.engine}")).read, binding)
      end
      
    end # ViewTemplate
  end # Mack
end # Mack

if __FILE__ == $0
  require 'pp'
  require 'erubis'
  require 'mack_ruby_core_extensions'
  fa = "/Users/markbates/mack/test/fake_application"
  vt = Mack::Rendering::ViewTemplate.new(:format => :html)
  vt.add_options(:layout => "#{fa}/views/layouts/application", :action => "foo", :controller => "tst_home_page", :file_path => fa)
  pp vt
  pp vt.compile
end